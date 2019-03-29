---
title: How to Use AWS Cloudfront to Serve Kong Dev Portal Assets
toc: false
---

### Introduction

Amazon CloudFront is a fast content delivery network (CDN) service that securely
 delivers data, videos, applications, and APIs to customers globally with low 
 latency, high transfer speeds.

In this guide we will create an Amazon S3 bucket, and an Amazon CloudFront 
distribution to serve static assets for your Kong Developer Portal.


### Prerequisites

AWS Account Credentials (with permissions to create S3 buckets, and CloudFront distributions)


## Step 1 - Create a new Amazon S3 Bucket

![Create New Bucket](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/aws-bucket.png)

## Step 2 - Upload an asset to the S3 bucket using "Standard" storage class

![Upload Image](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/upload-image.png)


## Step 3 - Create a new Amazon CloudFront Distribution

![Create Distribution](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/creat-distribution.png)

## Step 4 - Select the S3 Bucket as your origin

![Select Origin](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/origin-settings.png)

## Step 5 - Restrict the S3 Bucket to only be read by this CloudFront distribution

![Restrict Access](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/restrict-access.png)

## Step 6 - Enabled GZIP 

![Enable GZIP](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/enable-gzip.png)

## Step 7 - Save and wait for the CloudFront distribution to be ready

![Save](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/save-distribution.png)

## Step 9 - Make your Images Public

Once your distribution is ready, find the image you want to use in your S3 Bucket and make it accessible publically.

![Make Images Public](https://s3.us-east-2.amazonaws.com/kong-doc-assets/developer-portal/how-to/aws-cloudfront/make-public.png)

You can now copy the `Object URL` for the image and use it in the Dev Portal.

### FAQs

1. Why am I getting a “Access Denied” when requesting the “logo.png” through my Cloudfront URL?

    This is a DNS redirect that S3 does by default on newly created buckets. The bucket's DNS has not fully propagated to <name>.s3.amazonaws.com, you can do one of two things:

    a. Wait for the DNS to propagate

    b. Change the “Origin” on your “Cloudfront Distribution” to be the exact bucket URI such as <name>.s3-us-west-1.amazonaws.com

    If you are still seeing this error after 48 hours, check that the image
    has been set to `public` as seen in Step 9
