---
id: page-install-method aws-cloudformation
title: Install - AWS Cloud Formation
header_title: AWS Cloud Formation
header_icon: /assets/images/icons/icn-installation.svg
redirect_from: /install/aws/
breadcrumbs:
  Installation: /install
links:
  aws: "https://console.aws.amazon.com/cloudformation/home"
  templates:
    kong-hvm: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-cassandra-user-vpc-optional-hvm.template"
    kong-pv: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-cassandra-user-vpc-optional-pv.template"
    kong-postgres-hvm: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-postgres-optional-vpc-optional-hvm.template"
    kong-postgres-pv: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-postgres-optional-vpc-optional-pv.template "
---

### Templates

#### Kong with Cassandra

This template will provision Kong instances in a new or existing VPC. You will
need to provide the contact points of your Cassandra cluster during the
deployment process.

##### HVM AMI

- [us-east-1]({{ page.links.aws }}?region=us-east-1#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})
- [us-west-1]({{ page.links.aws }}?region=us-west-1#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})
- [us-west-2]({{ page.links.aws }}?region=us-west-2#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})
- [eu-west-1]({{ page.links.aws }}?region=eu-west-1#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})
- [ap-northeast-1]({{ page.links.aws }}?region=ap-northeast-1#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})
- [ap-southeast-1]({{ page.links.aws }}?region=ap-southeast-1#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})
- [ap-southeast-2]({{ page.links.aws }}?region=ap-southeast-2#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})
- [sa-east-1]({{ page.links.aws }}?region=sa-east-1#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-hvm }})

##### PV AMI

- [us-east-1]({{ page.links.aws }}?region=us-east-1#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})
- [us-west-1]({{ page.links.aws }}?region=us-west-1#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})
- [us-west-2]({{ page.links.aws }}?region=us-west-2#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})
- [eu-west-1]({{ page.links.aws }}?region=eu-west-1#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})
- [ap-northeast-1]({{ page.links.aws }}?region=ap-northeast-1#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})
- [ap-southeast-1]({{ page.links.aws }}?region=ap-southeast-1#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})
- [ap-southeast-2]({{ page.links.aws }}?region=ap-southeast-2#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})
- [sa-east-1]({{ page.links.aws }}?region=sa-east-1#/stacks/new?stackName=kong-elb-pv&templateURL={{ page.links.templates.kong-pv }})

#### Kong with PostgreSQL

This template will provision Kong instances in a new or existing VPC. You can
provide your own PostgreSQL instance, or if not, the template will create one
on AWS RDS for you.

##### HVM AMI

- [us-east-1]({{ page.links.aws }}?region=us-east-1#/stacks/new?stackName=kong-elb-postgres-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})
- [us-west-1]({{ page.links.aws }}?region=us-west-1#/stacks/new?stackName=kong-elb-postgres-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})
- [us-west-2]({{ page.links.aws }}?region=us-west-2#/stacks/new?stackName=kong-elb-postgres-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})
- [eu-west-1]({{ page.links.aws }}?region=eu-west-1#/stacks/new?stackName=kong-elb-postgres-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})
- [ap-northeast-1]({{ page.links.aws }}?region=ap-northeast-1#/stacks/new?stackName=kong-elb-postgres-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})
- [ap-southeast-1]({{ page.links.aws }}?region=ap-southeast-1#/stacks/new?stackName=kong-elb-postgres-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})
- [ap-southeast-2]({{ page.links.aws }}?region=ap-southeast-2#/stacks/new?stackName=kong-elb-postgres-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})
- [sa-east-1]({{ page.links.aws }}?region=sa-east-1#/stacks/new?stackName=kong-elb-hvm&templateURL={{ page.links.templates.kong-postgres-hvm }})

##### PV AMI

- [us-east-1]({{ page.links.aws }}?region=us-east-1#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})
- [us-west-1]({{ page.links.aws }}?region=us-west-1#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})
- [us-west-2]({{ page.links.aws }}?region=us-west-2#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})
- [eu-west-1]({{ page.links.aws }}?region=eu-west-1#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})
- [ap-northeast-1]({{ page.links.aws }}?region=ap-northeast-1#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})
- [ap-southeast-1]({{ page.links.aws }}?region=ap-southeast-1#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})
- [ap-southeast-2]({{ page.links.aws }}?region=ap-southeast-2#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})
- [sa-east-1]({{ page.links.aws }}?region=sa-east-1#/stacks/new?stackName=kong-elb-postgres-pv&templateURL={{ page.links.templates.kong-postgres-pv }})

----
### Recommended usage

  <B>Use this cloud formation as a basis for your own, adjust the variables and template to better suite your needs.</B>
----

### Instructions

1. **Initial Setup**

    Create the required key pair to access your Kong instances. If you are
    providing your own Cassandra/PostgreSQL instances, make sure they are
    accessible from your Kong instances. If you want to create instances in
    an existing VPC, this VPC needs to have two public subnets, and all
    required ports open to allow access to the Kong Load Balancer.

    *Continue to next step if you want to use an existing key pair*

3. **Choose a Region & VM Type**

    Choose the region closest to your API servers, and pick the virtualization
    type you'd like from the list of available [templates](#templates) above.

    You should land on AWS Cloud Formation *"Select Template"* page

4. **Parameters**

    Fill-in all the parameters details. If you chose to launch Kong with
    PostgreSQL but without specifying your own PostgreSQL server, you will be
    asked to fill-in a few extra parameters to create a PostgreSQL RDS
    instance. Check the description of each field and provide the appropriate
    values.

    **Note**: *consult the [templates documentation on Github]({{ site.repos.cloudformation }}) for detailed description of parameters*

5. **Option page**

    Add Tags and other fields according to your requirements.

    **Note:** *The template is configured to add a "Name" tag to each relevant resource*

5. **Template Documentation**

    For more details on parameters and futher configuration options, please consult the [templates documentation on Github]({{ site.repos.cloudformation }})

6. **Grab a Coffee!**

    It will take several minutes *(~20 minutes)* to create the stack. Once the stack has a status of `CREATE_COMPLETE`, click on the *"Output"* tab to get the Proxy and Admin URLs, it may take *60 more seconds* for the links to become active.

    **Note**: *To monitor the progress go to AWS CloudFormation console, select the stack in the list. In the stack details pane, click the "Events" tab to see the progress.*

    <div class="alert alert-warning">
      <div class="text-center">
        <strong>Note</strong>: Check out the <a href="{{ site.repos.cloudformation }}">kong-dist-cloudformation</a> repository for further details.
      </div>
    </div>

7. **Use Kong**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
