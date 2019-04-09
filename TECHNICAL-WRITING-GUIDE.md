# Kong's Technical Writing Guide

### Table of Contents

- [Introduction](#introduction)
- [Style and Tone](#style-and-tone)
- [Types of Documentation and Structure](#types-of-documentation-and-structure)
  - [Reference Documentation](#reference-documentation)
  - [Explanatory Documentation](#explanatory-documentation)
  - [How-To Guides](#how-to-guides)
  - [Tutorials](#tutorials)


### Introduction

Kong's documentation community is growing. That means there are more and more 
people writing, commenting, editing, and otherwise contributing to Kong's 
official documentation. But with more contributors comes more variation in
writing style, so in order to maintain a consistent voice and style throughout
all of Kong's documentation, we have curated a set of technical writing guidelines. 

To decrease the turn-around time for publishing docs, we ask that all
contributors read through this guide in its entirety, reference our 
[Styleguide](/STYLEGUIDE.md), and consider using one of Kong's documentation
[templates](/templates).


## Style and Tone

When writing documentation for Kong ask yourself the following questions:

**1. Is it friendly?**

Here at Kong we maintain an approachable yet professional tone. This means docs
should:

- be written for all experience levels
- be written in first person plural, e.g., "we"
- avoid placing "blame" on the user
- avoid excessive jokes or informal jargon


**2. Is it helpful?**

Will this document or update help users to understand a new concept, set up
something from scratch, or answer a question?

Writers and editors for Kong docs should strive to cover their topic thoroughly 
and succinctly. The goal is to help users accomplish a task from start to finish
or learn something rather than just copy and paste bits of code. Documentation
should also help guide users to other relevant pages or resources.

**3. Is it true?**

Kong documentation should be technically accurate and contain enough detail to 
provide users with the correct context. Before publishing, writers should have
other contributors review and verify the technical accuracy of a document. This
process ensures that users will be able to follow a doc from start to finish.

## Types of Documentation and Structure

Kong docs contain four types of documentation


### Reference documentation

This type of documentation is strictly informative, such as the descriptions of API
endpoints or configuration properties.


### Explanatory documentation

Explanatory guides provide in-depth clarification and examples, generally split
up into multiple sections.

Explanatory documentation should include:

* Title
* Section 1
    * Elaboration
    * Example
* Section ...
    * Elaboration
    * Example
* Section N
    * Elaboration
    * Example
* Related article

Avoid overly specific edge cases as generally these are more appropriate for
How-To guides or Tutorials. Each section should begin with a topic sentence
followed by one or more paragraphs that elaborate on the topic and provide
examples. The purpose of explanatory documentation is to help a user understand
a specific concept.


### How-to Guides

How-to guides should solve an explicit problem or accomplish a specific task
such as “How to Delete an Admin”

They should follow the following structure:

* Title
* Table of Contents
* Introduction
* Prerequisites
* Step 1 
* Step 2
* Step ...
* Step n
* Optional next steps or related article

Our [How-to template](/templates/how-to.md) has this layout available in Markdown for you to use as
a starting point.

*Title [h1]*

How-to guide titles typically follow the “How to [X] using [Y]” format.

*Table of Contents [h4]*
 
 - Bulleted list of each step in the guide

*Introduction [h3]*

How-to guides should start with an introduction. It should be limited to a few
succinct sentences or paragraphs that introduces what the user will be learning
to do. A How-to guide should provide an end-goal, or something that the user
will accomplish by following the steps. 

*Prerequisites [h3]*

* A bulleted list of everything a user needs to complete the how-to guide

*Steps [h2]*

Begin each step with an h2 heading containing a summary statement, followed by
a brief introduction of what the step will accomplish. Please be thorough in
explaining not only what to a user needs to do in each step but also why. We
want users to walk away with an understanding of what they accomplished,
rather than just copying and pasting code.

*Next Steps [h3] [optional]*

After completing the how to guide, consider including a related article or
“next steps”. Most guides will relate directly to a property reference, an
explanatory doc, or be a prerequisite to another guide, including this
information will help guide users through our documentation.


### Tutorials

Kong tutorials should be goal oriented and walk a user through an entire process,
from start to finish. They should contain explicit instructions and examples,
with complete code snippets and screenshots. A tutorial will state something
along the lines of “In this tutorial we will do *X*”. 
