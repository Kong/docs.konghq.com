const https = require('https');
const fs = require('fs');
const path = require('path');
const nlp = require('compromise'); // Import the compromise library

const apiKey = process.env.BEAMER_API_KEY;
// const filePath = process.env.FILE_PATH;
const filePath = __dirname + "/../../app/konnect/updates.md";
const options = {
    hostname: 'api.getbeamer.com',
    port: 443,
    path: '/v0/posts',
    method: 'GET',
    headers: {
        'Beamer-Api-Key': apiKey,
    }
};
const monthNames = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

function cleanHTML(contentHtml) {
    if (!contentHtml) return '';
    return contentHtml
        .replace(/<[^>]*>/g, '') // Remove HTML tags
        .replace(/\s+/g, ' ')    // Replace multiple spaces/newlines with a single space
        .trim();                 // Trim leading and trailing spaces
}

// Function to summarize content using compromise
function summarizeContent(content, maxSentences = 2) {
    const doc = nlp(content);
    const sentences = doc.sentences().out('array');
    
    // Extract and join the first 'maxSentences' sentences
    const summary = sentences.slice(0, maxSentences).join(' ').trim();
    return summary;
}

// Function to clean and summarize content
function cleanContent(content) {
    const cleanedContent = content.replace(/\s+/g, ' ').trim();
    return summarizeContent(cleanedContent); // Summarize the cleaned content
}

const req = https.request(options, (res) => {
    let data = '';

    res.on('data', (chunk) => {
        data += chunk;
    });

    res.on('end', () => {
        try {
            const posts = JSON.parse(data);
            const groupedPosts = {};

            posts.forEach(post => {
                const date = new Date(post.date);
                const month = monthNames[date.getMonth()];
                const year = date.getFullYear();
                const day = String(date.getDate()).padStart(2, '0');
                const monthYear = `${month} ${year}`;
                const formattedDate = `${month} ${day}`;

                if (!groupedPosts[monthYear]) {
                    groupedPosts[monthYear] = [];
                }

                post.translations.forEach(translation => {
                    // Check if 'konnect' is part of the category
                    if (translation.category.split(';').some(cat => cat.trim().toLowerCase() === 'konnect')) {
                        let contentPreview = translation.content ? cleanContent(translation.content) : cleanHTML(translation.contentHtml);
                        groupedPosts[monthYear].push({
                            date: formattedDate,
                            title: translation.title,
                            postUrl: translation.postUrl,
                            content: contentPreview,
                        });
                    }
                });
            });

            let updatesContent = '';

            for (const [monthYear, posts] of Object.entries(groupedPosts)) {
                // Add the month and year heading before the posts for that month
                updatesContent += `## ${monthYear}\n\n`;

                posts.forEach(post => {
                    updatesContent += `<div class="changelog-entries">\n`;
                    updatesContent += `<div class="changelog-date">${post.date}</div>\n`;
                    updatesContent += `<div class="changelog-entry">\n`;
                    updatesContent += `<div class="changelog-title">\n`;
                    updatesContent += `<a href="${post.postUrl}">${post.title}</a>\n`;
                    updatesContent += `</div>\n`;
                    
                    if (post.content) {
                        updatesContent += `<div class="changelog-description">${post.content}</div>\n`;
                    }
                    
                    updatesContent += `</div>\n`;
                    updatesContent += `</div>\n`;
                });
            }

            fs.readFile(filePath, 'utf8', (err, data) => {
                if (err) {
                    console.error('Error reading file:', err);
                    return;
                }

                const match = data.match(/## \w+ \d{4}/);
                if (!match) {
                    console.error('First month heading not found in file.');
                    return;
                }
                const insertIndex = match.index;

                const newContent = `${data.slice(0, insertIndex)}${updatesContent}\n${data.slice(insertIndex)}`;

                fs.writeFile(filePath, newContent, 'utf8', (err) => {
                    if (err) {
                        console.error('Error writing to file:', err);
                        return;
                    }

                    console.log('Updates added successfully!');
                });
            });
        } catch (error) {
            console.error('Error parsing response:', error);
        }
    });
});

req.on('error', (e) => {
    console.error('Error making request:', e);
});

req.end();
