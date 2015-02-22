# This is to work around a bug with fig and data conatiners
# See https://github.com/docker/fig/issues/613 for details

fig up -d data followdata
fig up db follower
fig rm db follower
