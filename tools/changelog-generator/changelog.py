import requests
import os
from datetime import datetime, timedelta


base_url = 'https://api.github.com'
repo = 'Kong/docs.konghq.com'
current_directory = os.getcwd()
file_path = os.path.join(current_directory, 'docs_changelog.md')


today = datetime.now()
last_week = today - timedelta(days=7)

since = last_week.date().isoformat()
until = today.date().isoformat()

#api_key = 'insert API key'
api_key = os.getenv('API_KEY')

pr_url = f'{base_url}/repos/{repo}/pulls?state=closed&base=main&sort=updated&direction=desc&since={since}&until={until}'


headers = {
    'Authorization': f'Token {api_key}'
}


pr_response = requests.get(pr_url, headers=headers)


if pr_response.status_code == 200:
    prs = pr_response.json()

    
    markdown_content = ""

   
    current_week_title = f"## {last_week.strftime('%Y-%m-%d')} - {today.strftime('%Y-%m-%d')}"
    markdown_content += current_week_title + "\n\n"

    
    for pr in prs:
        pr_number = pr['number']
        pr_title = pr['title']
        pr_user = pr['user']['login']
        pr_url = pr['html_url']
        commit_sha = pr['merge_commit_sha']

        
        commit_url = f'{base_url}/repos/{repo}/commits/{commit_sha}'

        
        commit_response = requests.get(commit_url, headers=headers)

        
        if commit_response.status_code == 200:
            commit = commit_response.json()
            #commit_name = pr_title

            
            files = commit['files']
            new_files = [file['filename'] for file in files if file['status'] == 'added' and file['filename'].startswith('app/_src/')]
            updated_files = [file['filename'] for file in files if file['status'] == 'modified' and file['filename'].startswith('app/_src/')]

            
            markdown_content += f"### PR #{pr_number}: [{pr_title}]({pr_url})\n"
            #markdown_content += f"- Commit: {commit_name}\n"

            
            if new_files:
                markdown_content += "\n**New**\n\n"
                for file in new_files:
                    parts = file.split('/')
                    product_name = parts[2] 
                    url = f"https://docs.konghq.com/{product_name}/latest/{'/'.join(parts[3:]).replace('.md', '')}"
                    markdown_content += f"- [{file}]({url})\n"

            
            if updated_files:
                markdown_content += "\n**Updates**\n\n"
                for file in updated_files:
                    parts = file.split('/')
                    product_name = parts[2] 
                    url = f"https://docs.konghq.com/{product_name}/latest/{'/'.join(parts[3:]).replace('.md', '')}"
                    markdown_content += f"- [{file}]({url})\n"

            markdown_content += "\n---\n\n"
        else:
            print(f'Error: Failed to get commit details. Status code: {commit_response.status_code}')
else:
    print(f'Error: Failed to get pull requests. Status code: {pr_response.status_code}')


with open('docs_changelog.md', 'r') as file:
    existing_content = file.read()


new_content = markdown_content + existing_content


with open(file_path, 'w') as file:
    file.write(new_content)
