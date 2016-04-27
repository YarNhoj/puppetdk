# puppetdk
This is a docker image for writting puppet code. It uses puppet-vim, puppet 4.4.1, and hiera_explain gem.

Example usage
cd to code dir

docker run -it --rm -v $(pwd):/puppet yarnhoj/puppetdk
