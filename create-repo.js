const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const repoPath = process.argv[2] || '.';
const githubToken = process.argv[3] || process.env.GITHUB_TOKEN;
const repoName = 'picoclaw-rpi3b-firmware';

if (!githubToken) {
  console.log('GITHUB_TOKEN not found. Set it as environment variable or pass as argument.');
  console.log('Example: node create-repo.js . YOUR_TOKEN_HERE');
  process.exit(1);
}

console.log('Initializing git repository...');

try {
  // Initialize git if not already
  execSync('git init', { cwd: repoPath, stdio: 'ignore' });
  execSync('git add .', { cwd: repoPath, stdio: 'ignore' });
  execSync('git commit -m "Initial PicoClaw RPI3B+ firmware v1.0"', { cwd: repoPath, stdio: 'ignore' });
  console.log('Git repository initialized and committed');
} catch (e) {
  console.log('Git init error:', e.message);
}

// Create GitHub repo using API
console.log('Creating GitHub repository...');

const { http } = require('http');

const postData = JSON.stringify({
  name: repoName,
  description: 'PicoClaw AI Assistant firmware for Raspberry Pi 3B+ with pre-configured LLM providers',
  private: false,
  auto_init: false
});

const options = {
  hostname: 'api.github.com',
  path: '/user/repos',
  method: 'POST',
  headers: {
    'Authorization': `token ${githubToken}`,
    'Content-Type': 'application/json',
    'Accept': 'application/vnd.github.v3+json',
    'User-Agent': 'PicoClaw-Firmware-Builder'
  }
};

const req = http.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    if (res.statusCode === 201 || res.statusCode === 422) {
      console.log('Repository created or already exists!');
      console.log('Now add remote and push:');
      console.log(`  cd ${repoPath}`);
      console.log(`  git remote add origin https://github.com/YOUR_USERNAME/${repoName}.git`);
      console.log(`  git push -u origin main`);
    } else {
      console.log('Error creating repo:', res.statusCode, data);
    }
  });
});

req.on('error', (e) => {
  console.log('Request error:', e.message);
  console.log('Please create repo manually at: https://github.com/new');
});

req.write(postData);
req.end();