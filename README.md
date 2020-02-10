# WebApp Hosting Module

This module creates a number of AWS resources to enable the hosting of static websites and single page web applications.

Resources created include:

* An AWS S3 bucket used to deploy the web site / app. Note that this bucket is not publicly accessible.
* An AWS CloudFront CDN (Content Delivery Network) to distribute the web site / app. The CDN is set with a number of default settings:
  * HTTP access to the site is automatically redirected to HTTPs
  * The CDN assumes the default root object is `index.html`. This will be required in the root of the S3 bucket
  * The CDN is configured to only allow `GET`, `HEAD` and `OPTIONS` HTTP methods
  * Default TTL for cache is set to 300 seconds (5 minutes)
  * Max TTL is set to 3600 seconds (1 hour)
  * Content is distributed to US and Europe (Price Class 100)
  * No GEO restrictions are applied
  * No IP restictions are applied
* Issuance of a signed certificate that is used for HTTPS Access for the provided domain.
* A DNS record is created in the supplied hosted zone for the desired domain name.

## Pre-Requisites

An AWS Route53 hosted-zone entry is required on the AWS account that this module runs against. This Hosted Zone has 2 additional records added:

1. To enable the validation of the domain in support of issuing the HTTPs certificate
1. Creating the Domain URL for the App

## Usage

```terraform
module "<your_resource_name>" {
    hosted_zone  = "example.com."
    domain_name  = "www.example.com" 
    tags {
        client      = "abc ltd."
        application = "sample application"
        environment = "dev"
    }
}
```

## Input Variables

| Name                    | Description                                                                     | Type   | Default   | Required |
|-------------------------|---------------------------------------------------------------------------------|--------|-----------|----------|
| hosted_zone             | The Route53 hosted zone to be used for this service (e.g. example.com.)         | string | -         | yes      |
| domain_name             | A domain name for which the certificate should be issued (e.g. www.example.com) | string | -         | yes      |
| tags                    | Tags to apply to the S3 bucket resource                                         | map    | empty map | no       |

## Outputs

| Name                        | Description                                           |
|-----------------------------|-------------------------------------------------------|
| bucket_id                   | Bucket Name (aka ID)                                  |
| bucket_arn                  | Bucket ARN. Format: `arn:aws:s3:::bucketname`         |

## Potential Future Enhancements and Issues to Resolve / Consider

* Adding security headers to the response
* Enabling changes to Price Classes
* Enabling GEO restrictions
* Enabling IP address restrictions
* Renewing the HTTPS Certificate on Expiry
