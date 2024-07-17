#!/bin/bash -e

echo "Deploying..."

hugo --minify

aws s3 sync ./public s3://clickops-corner

invalidate=$(aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*")

echo "Deploy Successful!"