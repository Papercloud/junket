## Junket

[![Build Status](https://travis-ci.org/Papercloud/junket.svg?branch=master)](https://travis-ci.org/Papercloud/junket)

Power email and SMS campaigns in multi-tenant apps

Manage campaign templates, target users, send mail and SMS, and collect reporting.

#### Install Rubocop pre-commit hook
`curl https://gist.githubusercontent.com/tspacek/ddf8c4d63b110ab3c402/raw/1d1674c5ac93318d1cd45d8a37a140783fd94251/Rubocop%20pre-commit > .git/hooks/pre-commit; chmod 755 .git/hooks/pre-commit`

#### Re-generate Docs
`rake app:docs:generate`

#### TODOs
Need to record each recipient once sent, in case a Filter is deleted after using.