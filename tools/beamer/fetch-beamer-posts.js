const https = require('https');
const fs = require('fs');
const path = require('path');


const apiKey = process.env.BEAMER_API_KEY;
//const filePath = process.env.FILE_PATH;
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
        .replace(/<[^>]*>/g, '') // Remove HTML taags
        .replace(/\s+/g, ' ')    // Replace multiple spaces/ newlines with a single space
        .trim();                 // Trim leading and trailing spaces
}

// Function to clean content and remove newlines
function cleanContent(content) {
    return content.replace(/\s+/g, ' ').trim();
}

function convertCategoryToBadges(category) {
    if (!category) return '';
    return category
        .split(';')
        .map(cat => `{:.badge .${cat.trim().replace(/\s+/g, '-').toLowerCase()}}`) // Trim, replace spaces, and convert to lowercase
        .join(' ');
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
                    if (translation.category.includes('Konnect')) {
                        let contentPreview = translation.content ? cleanContent(translation.content) : cleanHTML(translation.contentHtml);
                        contentPreview = contentPreview.slice(0, 50) + (contentPreview.length > 50 ? '...' : '');
                        groupedPosts[monthYear].push({
                            date: formattedDate,
                            title: translation.title,
                            postUrl: translation.postUrl,
                            content: contentPreview,
                            category: convertCategoryToBadges(translation.category)
                        });
                    }
                });
            });

            let updatesContent = '';

            for (const [monthYear, posts] of Object.entries(groupedPosts)) {
                updatesContent += `## ${monthYear}\n\n`;
                posts.forEach(post => {
                    updatesContent += `${post.date} **[${post.title}](${post.postUrl})**\n`;
                    if (post.content) {
                        updatesContent += `: ${post.content}\n`;
                    }
                    updatesContent += `: ${post.category}\n\n`;
                });
            }

            fs.readFile(filePath, 'utf8', (err, data) => {
                if (err) {
                    console.error('Error reading file:', err);
                    return;
                }

                // Find the index of the first month heading
                const match = data.match(/## \w+ \d{4}/);
                if (!match) {
                    console.error('First month heading not found in file.');
                    return;
                }
                const insertIndex = match.index;

                // Combine the parts with the new updates inserted before the first month heading
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