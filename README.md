# Amazon Cloudfront Terraform Template

## Configuration

The following table lists the configurable parameters of the terraform template and their default values.

### Variables

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `aws_region`     | AWS Region      | `us-east-1`                                                    |


### Tags

A mapping of tags to assign to the resource. This can be any value you want added to the AWS RDS resources.

Example
```
tags {
  foo = "bar"
  action = "test"
}
```


## Example
```
module "cloudfront" {
  source  = "app.terraform.io/Exzeo/cloudfront/aws"
}
```

## Outputs
| Parameter               | Description                           | Example                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `cloudfront_id`     | The identifier for the distribution.  | `EDFDVBD632BHDS5`
| `cloudfront_arn` | The ARN (Amazon Resource Name) for the distribution. | `arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5`
| `cloudfront_domain_name` | The domain name corresponding to the distribution.  | `d604721fxaaqy9.cloudfront.net`
| `cloudfront_hosted_zone_id` | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. | `Z2FDTNDATAQYW2`

