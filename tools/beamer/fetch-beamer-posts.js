const https = require('https');
const fs = require('fs');
const path = require('path');

// const apiKey = process.env.BEAMER_API_KEY;
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

// Function to summarize content by extracting the first two sentences
function summarizeContent(content, maxSentences = 2) {
    const sentenceRegex = /[^.!?]*[.!?]/g;  // Regex to capture sentences
    const sentences = content.match(sentenceRegex) || []; // Match all sentences in the content
    
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
                const formattedDate = `${month}<br>${day}`;

                if (!groupedPosts[monthYear]) {
                    groupedPosts[monthYear] = [];
                }

                post.translations.forEach(translation => {
                    // Check if 'changelog' is part of the category
                    if (translation.category.split(';').some(cat => cat.trim().toLowerCase() === 'changelog')) {
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

            fs.readFile(filePath, 'utf8', (err, fileContent) => {
                if (err) {
                    console.error('Error reading file:', err);
                    return;
                }

                let newContent = fileContent;

                for (const [monthYear, posts] of Object.entries(groupedPosts)) {
                    const monthHeaderRegex = new RegExp(`##\\s*${monthYear}`, 'i');
                    let monthSection = '';

                    posts.forEach(post => {
                        monthSection += `<div class="changelog-entries">\n`;
                        monthSection += `<div class="changelog-date">${post.date}</div>\n`;
                        monthSection += `<div class="changelog-entry">\n`;
                        monthSection += `<div class="changelog-title">\n`;
                        monthSection += `<a href="${post.postUrl}">${post.title}</a>\n`;
                        monthSection += `</div>\n`;
                        
                        if (post.content) {
                            monthSection += `<div class="changelog-description">${post.content}</div>\n`;
                        }
                        
                        monthSection += `</div>\n`;
                        monthSection += `</div>\n`;
                    });

                    if (monthHeaderRegex.test(fileContent)) {
                        // Month heading exists, append the new content under that section
                        const headerIndex = newContent.search(monthHeaderRegex);
                        const nextHeaderIndex = newContent.slice(headerIndex + 1).search(/## \w+ \d{4}/); // Find the next month header
                        const endOfSectionIndex = nextHeaderIndex === -1 
                            ? newContent.length // If no next header, append to the end
                            : headerIndex + nextHeaderIndex + 1;

                        newContent = newContent.slice(0, endOfSectionIndex) + `\n` + monthSection + `\n` + newContent.slice(endOfSectionIndex);
                    } else {
                        // Month heading does not exist, find the appropriate place to insert it (above the existing headers)
                        const firstHeaderRegex = /##\s*\w+\s+\d{4}/;
                        const firstHeaderIndex = newContent.search(firstHeaderRegex);
                        if (firstHeaderIndex === -1) {
                            // No headings exist, append to the top
                            newContent = `## ${monthYear}\n\n${monthSection}\n\n${newContent}`;
                        } else {
                            // Insert above the first header, ensuring spacing between new and existing sections
                            newContent = `${newContent.slice(0, firstHeaderIndex)}## ${monthYear}\n\n${monthSection}\n\n${newContent.slice(firstHeaderIndex)}`;
                        }
                    }
                }

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
