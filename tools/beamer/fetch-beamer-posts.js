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
                const yearMonth = `${monthNames[date.getMonth()]} ${date.getFullYear()}`;

                if (!groupedPosts[yearMonth]) {
                    groupedPosts[yearMonth] = [];
                }

                post.translations.forEach(translation => {
                    groupedPosts[yearMonth].push({
                        title: translation.title,
                        postUrl: translation.postUrl
                    });
                });
            });

            let updatesContent = '';

            for (const [monthYear, posts] of Object.entries(groupedPosts)) {
                updatesContent += `## ${monthYear}\n\n`;
                posts.forEach(post => {
                    updatesContent += `**${post.title}**\n`;
                    updatesContent += `: [View in Konnect](${post.postUrl})\n\n`;
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