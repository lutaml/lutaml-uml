# LutaML syntax

## `diagram` syntax

`diagram` is a root element for each diagram.

```java
diagram MyView {
  import Relationship, Element
  render_option typed_as_associations
  file "my_view.png"
}
```

## Associations

### Undirected associations

The simplest way to define relationship between two classes is to use `generalize` keyword:

(TODO: RT: a generalization is already a directional relationship, isn't it?)

```java
class Pet {}
class Cat {
  generalize Pet
}
```

### Attribute relationship

Derived attribute `relatedElement` can have 1 to many `Element` associated with it through `union`

```java
class Relationship {
   +/relatedElement: Element[1..*] {union}
}
class Element {}
```

## Attribute definition

One can use "explicit" or "implicit" syntax for attribute definitions.

Explicit syntax:

```java
class A {
  attribute my_attribute
}

enum A {
  entry my_val2
}
```

implicit syntax:

```java
class A {
  my_attribute
}

enum A {
  my_val2
}
```


## Import files for parser

Use the keyword `include`:

```java
include path/to/file
```

## Package syntax

Namespaces

A named element is an element that can have a name and a defined visibility (public, private, protected, package).

The visibility may be expressed explicitly or via a shorthand:

* `+` => `public`
* `-` => `private`
* `#` => `protected`
* `~` => `package`

The name of the element and its visibility are optional.

```java
package Customers {
  class Insurance {}
  - class PrivateInsurance {}
  private class PrivateInsurance {}
  # class ProtectedInsurance {}
  protected class ProtectedInsurance {}
}
```

## Code comments

Use `//` notation for LutaML comments skipped by parser, example:

```java
// TODO: implement. This is not read by the LutaML parser.
abstract class Pet {}
```

## Comment objects diagram

Use `#` to create comment object for diagram entry or use `comment` notation to create object explicitly.

```java
class A as class_a
enum A as enum_a {
  # attribute foo, represents - attribute comment
  foo
  bar
}

# enum A, this is a comment to "enum A"

comment MyComment {
  My comment
}

class_a -> MyComment
enum_a -> MyComment
```

## Value specification

A value specification indicates one or several values in a model. Examples for value specifications include simple, mathematical expressions, such as 4+2, and expressions with values from the object model, Integer::MAX_INT-1

```java
class {Class name, if any} {as ref name, optional} {
  {attribute name} = {attribute value}
  {attribute name}:{attribute class} = {attribute value}
}

instance :{Class name, if any} {as ref name, optional} {
  {attribute name} = {attribute value}
  {attribute name}:{attribute class} = {attribute value}
}
```
