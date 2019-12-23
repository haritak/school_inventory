#!/bin/bash

echo "Precompiling assets for the production environment (ych)"
RAILS_ENV=production bin/rails assets:precompile

echo "Starting rails in production (ych)"
RAILS_ENV=production bin/rails server -b 0.0.0.0 -p 3000
