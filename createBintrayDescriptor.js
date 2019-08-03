const version = process.argv[2];
const now = new Date().toISOString().split('T')[0];

const json = {
    "package": {
        "name": "MagicMouse",
        "repo": "cmfcmf/MagicMouse",
        "subject": "cmfcmf",
        "issue_tracker_url": "https://github.com/cmfcmf/MagicMouse/issues",
        "vcs_url": "https://github.com/cmfcmf/MagicMouse.git",
        "github_use_tag_release_notes": true,
        "licenses": ["MIT"],
        "public_download_numbers": true,
        "public_stats": true
    },
    "version": {
        "name": version,
        "released": now,
        "gpgSign": false
    },
    "files": [{"includePattern": "build/(.*)", "uploadPattern": "$1"}],
    "publish": true
};

process.stdout.write(JSON.stringify(json));
