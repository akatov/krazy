# krazy.io

## get going

```bash
cd ~/src/bluemath
git clone git@bitbucket.org:bluemath/emilio.git
git clone git@github.com:akatov/krazy.git
cd krazy
curl https://install.meteor.com | /bin/sh
npm install -g meteorite
mrt --settings ../emilio/development.json
mrt deploy bluemath-krazy.meteor.com --settings ../emilio/production.json
```
