# CV

An XML language and associated ANT/XSLT package for building a CV.

## Creating the CV

The best way to create the CV is in oXygen XML Editor. Open oXygen and make sure to associate
the schema with the CV file. You can also use the template started for you in the document.

The schema will alert you if you've done something not allowed.

## Building

Clone the Github repo:

```
mkdir cv
git clone https://github.com/joeytakeda/cv
```

Make sure you have ANT installed on your computer and then run this command:

```
ant -lib utilities
```


