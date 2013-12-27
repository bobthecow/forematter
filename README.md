# Forematter

Forematter is the frontmatter-aware friend for your static site.


## Install Forematter

Add this line to your application's Gemfile:

```rb
gem 'forematter'
```

And then execute:

```bash
$ bundle
```

Or install it yourself, if that's what you're into:

```bash
$ gem install forematter
```

If you're not running a Ruby version manager, you might need to use `sudo gem install forematter` instead. But try it without the `sudo` first.


## Use Forematter for Good

Forematter makes it easy to add tags I forgot:

```bash
$ find . -name "*twitter*.md" | xargs fore add tags twitter
```

And find all of my dumb:

```bash
$ find . -name "*twitter*.md" | xargs fore list tags | grep -i tw
```

> Twitpocalypse  
> Twitter  
> twitter

... whoops. Let's fix that:

```bash
$ fore merge tags Twitter twitter *.md
$ find . -name "*twitter*.md" | xargs fore list tags | grep -i tw
```

> Twitpocalypse  
> Twitter

Much better!


## Use Forematter for Awesome

Forematter lets me automatically categorize all my blog posts, based on the tags I use:

```bash
# Grab the 10 most common tags from my blog
for c in $(fore count tags *.md | tail -10 | sort -r | awk '{print($2)}'); do
  # Set the category on each article with one of these tags
  fore search -l tags "$c" *.md | xargs fore set category "$c"
end

# Format categories as title case
fore cleanup category --titlecase *.md

# Automatically classify all articles which don't already have a category
fore classify category *.md
```

It does a lot more, too:

```bash
fore fields                        content/*.md
fore rename   categories tags      content/*.md

fore add      tags   foo bar       content/*.md
fore remove   tags   bacon         content/*.md
fore merge    tags   foo Foo       content/*.md
fore count    tags                 content/*.md
fore search   tags                 content/*.md
fore list     tags                 content/*.md

fore set      title  'title!'      content/foo.md
fore unset    title                content/bar.md
fore list     title                content/*.md

fore touch    updated_at           content/baz.md

fore cleanup  title --titlecase    content/*.md
fore cleanup  name  --capitalize   content/*.md
fore cleanup  tags  --downcase     content/*.md
fore cleanup  slug  --url          content/*.md
fore cleanup  title --trim         content/*.md
fore cleanup  tags  --sort         content/*.md

fore classify category             content/*.md
fore classify category --override  content/*.md

fore --help
```


## Use it in your shell

Forematter tries to be a good *nix citizen. It plays nice with `find` and `grep` and `awk`. Mix and match with all your favorite command line tools!


## Use it everywhere

Forematter isn't tied to any particular static site generator. If your files have [YAML frontmatter](http://jekyllrb.com/docs/frontmatter/), Forematter is the tool for you.

If you're looking for a great static site generator, go [check out this list — 210 of 'em and counting](http://staticsitegenerators.net)!

If Forematter doesn't work with your favorite, [let us know](https://github.com/bobthecow/forematter/issues/new).


## Buyer beware

Forematter works by _editing your site's content files_. There is a nonzero chance that you'll do something you regret, and Forematter can't help you ⌘Z.

If you're not keeping things under version control, this would be a good time to start!
