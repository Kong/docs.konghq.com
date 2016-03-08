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
    kong-cassandra-hvm: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-cassandra-hvm.template"
    kong-cassandra-pv: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-cassandra-pv.template "
    kong-hvm: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-hvm.template"
    kong-pv: "https://s3.amazonaws.com/kong-cf-templates/latest/kong-elb-pv.template"
---

### Templates:

#### Kong with Cassandra DB

Provision Kong resources along with a new Cassandra cluster, using The Datastax Cassandra AMI.

##### HVM AMI

- [us-west-1]({{ page.links.aws }}?region=us-west-1#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})
- [us-east-1]({{ page.links.aws }}?region=us-east-1#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})
- [us-west-2]({{ page.links.aws }}?region=us-west-2#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})
- [eu-west-1]({{ page.links.aws }}?region=eu-west-1#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})
- [ap-northeast-1]({{ page.links.aws }}?region=ap-northeast-1#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})
- [ap-southeast-1]({{ page.links.aws }}?region=ap-southeast-1#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})
- [ap-southeast-2]({{ page.links.aws }}?region=ap-southeast-2#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})
- [sa-east-1]({{ page.links.aws }}?region=sa-east-1#/stacks/new?stackName=kong-elb-cassandra-hvm&templateURL={{ page.links.templates.kong-cassandra-hvm }})

##### PV AMI

- [us-east-1]({{ page.links.aws }}?region=us-east-1#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})
- [us-west-1]({{ page.links.aws }}?region=us-west-1#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})
- [us-west-2]({{ page.links.aws }}?region=us-west-2#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})
- [eu-west-1]({{ page.links.aws }}?region=eu-west-1#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})
- [ap-northeast-1]({{ page.links.aws }}?region=ap-northeast-1#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})
- [ap-southeast-1]({{ page.links.aws }}?region=ap-southeast-1#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})
- [ap-southeast-2]({{ page.links.aws }}?region=ap-southeast-2#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})
- [sa-east-1]({{ page.links.aws }}?region=sa-east-1#/stacks/new?stackName=kong-elb-cassandra-pv&templateURL={{ page.links.templates.kong-cassandra-pv }})

#### Kong without Cassandra DB

Provisions Kong resources with user provided Cassandra seed nodes.

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

----
### Recommended usage:

	<B>Use this cloud formation as a basis for your own, adjust the variables and template to better suite your needs.</B>
----

### Instructions:

1. **Key Pairs**:

    Create two sets of key pairs, one to access Cassandra instances & one for Kong instances. *Continue to next step if you want to use an existing key pair*

3. **Choose a Region & VM Type**:

    Choose the region closest to your API servers, and pick the virtualization type you'd like from the list of available [templates](#templates) above.

    You should land on AWS Cloud Formation *"Select Template"* page

4. **Parameters**:

    Fill in all the parameters details. If you chose to launch Kong with Cassandra you would be asked to fill in extra parameters to create a Cassandra cluster. check the description of each field and provide appropriate values.

    **Note**: *consult the [templates documentation on Github]({{ site.repos.cloudformation }}) for detailed description of parameters*

5. **Option page**:

    Add Tags and other fields according to your requirements.

    **Note:** *The template is configured to add a "Name" tag to each relevant resource*

5. **Template Documentation**:

    For more details on parameters and futher configuration options, please consult the [templates documentation on Github]({{ site.repos.cloudformation }})

6. **Grab a Coffee!**:

    It will take several minutes *(~20 minutes)* to create the stack. Once the stack has a status of `CREATE_COMPLETE`, click on *"Output"* tab to get the proxy and Admin URL, it may take *60 seconds* more for links to become active.

    **Note**: *To monitor the progress go to AWS CloudFormation console, select the stack in the list. In the stack details pane, click the "Events" tab to see the progress.*

    <div class="alert alert-warning">
      <div class="text-center">
        <strong>Note</strong>: Check out the <a href="{{ site.repos.cloudformation }}">kong-dist-cloudformation</a> repository for further details.
      </div>
    </div>

7. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
