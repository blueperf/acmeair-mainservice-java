acmeair-# Building acmeair main service using Eclipse

These instructions assume you 
1. Have git tools installed in Eclipse (These should be included by default).

###### Clone Git Repo

If the sample git repository hasn't been cloned yet, use git tools integrated into the IDE:

1.  Open the Git repositories view
    * *Window -> Show View -> Other*
    * Type "git" in the filter box, and select *Git Repositories*
2.  Copy Git repo url by finding the textbox under "HTTPS clone URL" at the top of this page, and select *Copy to clipboard*
3.  In the Git repositories view, select the hyperlink `Clone a Git repository`
4.  The git repo url should already be filled in.  Select *Next -> Next -> Finish*
5.  The "acmeair-mainservice-java [master]" repo should appear in the view

###### Import Maven projects into WDT

1.  In the Git Repository view, expand the acmeair-mainservice-java repo to see the "Working Directory" folder
2.  Right-click on this folder, and select *Copy path to Clipboard*
3.  Select menu *File -> Import -> Maven -> Existing Maven Projects*
4.  In the Root Directory textbox, Paste in the repository directory.
5.  Select *Browse...* button and select *Finish* (confirm it finds 1 pom.xml files)
6.  This will create 1 projects in Eclipse: acmeair-mainservice-java

###### Run Maven install

1. Right-click on acmeair-mainservice-java/pom.xml
2. *Run As > Maven build...*
3. In the *Goals* section enter "package"
4. Click *Run*

*Note:* If you did not use Eclipse to clone the git repository, follow from step 3, but navigate to the cloned repository directory rather than pasting its name in step 4.

This will download prerequisite jars and build:  
* acmeair-mainservice-java/target/acmeair-mainservice-java-3.0.0-SNAPSHOT.war  


# Building acmeair main service using the Command Line


###### Add Java to your path and set your JAVA_HOME environment variable appropriately
Windows:

	set JAVA_HOME=C:\work\java\ibm-java-sdk-7.1-win-i386
	set PATH=%JAVA_HOME%\bin;%PATH%

Linux:

	export JAVA_HOME=~/work/java/ibm-java-sdk-7.1-i386
	export PATH=$JAVA_HOME/bin:$PATH


###### Install the following development tools

* Git for access to the source code (http://msysgit.github.io/ for windows)
* Maven for building the project (https://maven.apache.org/download.cgi)
* Ensure git and maven are on your PATH

##### Clone Git Repo

	git clone https://github.com/BluePerf/acmeair-mainservice-java.git

##### Building the sample

  
	cd <acmeair-mainservice-GIT-PATH>  
	mvn clean package

This will download prerequisite jars and build:  
* acmeair-mainservice-java/target/acmeair-mainservice-java-3.0.0-SNAPSHOT.war   