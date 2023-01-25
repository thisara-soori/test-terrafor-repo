# ai-git-tagger

This module allows developers of other modules or deployments to automatically tag resources
that are created with metadata about context, under which the corresponding `terraform apply` command was executed.

Thus, it allows to quickly understand, when/how a particular resource was created.

# How to use it?

## Importing module
If you are developing a **module** (let's say `modules/aws/aws-instance`), add the following to your `main.tf`:

```
module "git_tags" {
  source = "../../ai-git-tagger"
}
```

If you are developing a **deployment** using raw resources, not common modules, 
you can use this module by:

```
module "git_tags" {
  source = "../../modules/ai-git-tagger"
}
```

## Adding tags

And, wherever you are declaring your resources, you can add:

```
tags = module.git_tags.tags
```

or, if you already have some tags, just merge them, e.g.:

```
tags = merge(
  var.tags,
  module.git_tags.tags,
  {
    "Name": var.name
  }
)
```

Note - both Azure and AWS have `tags` attribute for most resource types. GCP has a similar concept called `labels`. If/when GCP will be introduced, make sure all values are 64 characters max.


