## Deploy to github

http://andy4thehuynh.github.io/post/hugo--simple-deploy-to-github-pages/

## get source

```
git clone git@github.com:spencergibb/spencergibb.github.io.git
git checkout --track -b source origin/source
```

## get themes

`$ git clone --recursive https://github.com/spf13/hugoThemes.git themes`

## get generated content in master

```
git clone git@github.com:spencergibb/spencergibb.github.io.git public
```

## build

`./deploy.sh`