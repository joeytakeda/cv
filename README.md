# CV

An XML language and associated ANT/XSLT package for building a CV.

## Creating the CV

The best way to create the CV is in oXygen XML Editor. Open oXygen and make sure to associate
the schema with the CV file. You can also use the template started for you in the document.

The schema will alert you if you've done something not allowed.

## Setup

Clone the Github repo:

```
mkdir cv
cd cv
git clone https://github.com/joeytakeda/cv
```

If you have oXygen installed on your computer, you can skip the following steps.

Check if you have ANT installed on your computer by running:

```
ant -h
```

If it gives you a list of options, then hooray! It's installed. If it says that "ant cannot be found" or something similar, then you'll need to install ant using Homebrew.

Check to see if brew is installed:

```
brew help
```

Same as above--if you don't see a list of options, then you'll have to install homebrew (which is quite useful!). You can brew homebrew using this (taken from the Homebrew site: https://brew.sh/)


```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Once homebrew is installed, download ant:

```
brew install ant
```

## Building

Once you have Ant installed on your computer, run 

```
ant -lib utilities
```

This will create a PDF, HTML, and other versions of your CV.

You can adjust the data/sample.xml to fit your needs. Order of the elements do not matter, usually. Follow the prompts given by the schema.

For a longer example, see https://github.com/joeytakeda/joeytakeda.github.io/blob/master/xml/CV.xml


