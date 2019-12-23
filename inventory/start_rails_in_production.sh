#!/bin/bash
export RAILS_MASTER_KEY=$(bin/rails secret)

echo $RAILS_MASTER_KEY

RAILS_ENV=production bin/rails server -b 0.0.0.0 -p 3000
