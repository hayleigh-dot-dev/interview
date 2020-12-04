const qItem = (key, title, image, description) => ({
  key: key,
  title: title,
  description: description,
  image: image ? `images/${key}-${image}.png` : '',
  rating: 'Neutral'
})

Array.prototype.shuffle = function () {
  return this.map(function (n) { return [Math.random(), n] })
    .sort().map(function (n) { return n[1] });
}

export const all = {
  type: 'BasicSort',
  title: 'Programming Language Features',
  description: `In the two-part task below you'll need to rate various programming
  language features according to positively or negatively they impact your
  programming practice. In the second portion of the task you'll then be asked to
  order the statements from "Most negatively impactful" through "Not impactful" to
  "Most positively impactful". Each language feature has a brief description and
  sometimes an example image or code snippet. If you're unsure how to rate a feature
  rate it as Neutral.`,
  statements: [],
  unsorted: [
    qItem('01', 'The ability to restrict or constrain function arguments', 'dependent-types', [
      `Known as "dependent typing", this type system allows a type's definition
      to depend on a value.`,
      `In the example above, the factorial function is defined. It takes one
      argument, an integer, but has an additional constraint applied to it. The
      factorial function can only be called with natural numbers: numbers
      greater than zero.`,
      `Attempting to call factorial(-1) would result in a compile-time error
      meaning less run-time code is dedicated to input validation.`
    ]),
    qItem('02', 'Objects with the same members or structure may be used interchangeably', 'structural-typing', [
      `Known as "structural typing", this system allows objects to be considered
      equal if they share the same members.`,
      `In the code snippet, values of both the Person and Employee types
      can be passed to the greet function as they both have a "name" field.`
    ]),
    qItem('03', 'The language has tagged union types to describe variants of a single type', 'sum-types', [
      `Tagged unions, also known as "disjoint unions" are used to describe
      a value that can take several different, but fixed, types. A special tag
      is used to explicitly indicate which variant a value currently is.`,
      `A traditional enum could be considered the most basic example of a tagged
      union. Each member of the enum is a distinct tag such as Red, Orange, and
      Green in the example above.`,
      `Each variant in the union can also store differing pieces data, as is the
      case in the AudioNode example. The Oscillator variant holds Float values
      for frequency and phase, while the Gain variant holds a single Float value
      for amount.`,
      `Finally, tagged unions can be parameterised for generic use of the type.
      The Result type defined above has two variants, Success and Error, and two
      type parameters, e and a. Depending on the needs of the programmer, types
      such as "Result String Int" can now be used to indicate a value that may
      be an error string or an integer.`
    ]),
    qItem('04', 'The language has untagged union types to unify several existing types', 'union-types', [
      `Similar to disjoint unions, untagged unions describe a value that can be
      one of sevaral types. As the name implies, untagged unions do not "tag"
      each variant.`,
      `Untagged unions are used to say a value could be of type a OR type b, as
      in the example above. The C code above defines a union of an int and a
      float, and provides a mechanism to access either value. A similar thing
      can be acheived in typescript, for example: "type foo = number | string".`
    ]),
    qItem('05', 'Types are dynamic and determined at run-time', 'dynamic-typing', [
      `In dynamically typed languages, types are fluid and determined while the
      program is running.`,
      `This makes it easy for developers to maniupulate and transform values,
      but comes at the cost of having to check types manually at runtime.`,
      `The snippet shows how to check the type of a variable in javascript,
      and shows that the type of a variable can change over it's lifetime.`
    ]),
    qItem('06', 'The language has a static type system that determines type correctness at compile-time', 'static-typing', [
      `In statically typed languages, the type of a value is determined at compile
      time and the compiler performs checks to ensure all the types in a program
      match up.`,
      `Attempting to call a function that only takes integers with a string for
      example, will result in a compile time error forcing the developer to fix
      the problem.`,
      `Some languages require all values and functions to have "type annotations"
      whereas others can infer types based on their useage while still enforcing
      correctness.`
    ]),
    qItem('07', 'The language has an undefined and/or null type and value', 'undefined-and-null', [
      `Some languages have the notion of "undefined" or "null" (or both) to
      describe values that do not exist.`,
      `In javascript undefined is returned when trying to access object properties
      that do not exist, and null is used to explicitly describe something with
      no value.`,
      `In the snippet, the greet function checks if the object has the
      property "name" and uses that in the greeting if it exists. If no element
      has the id "superCoolElement", then null is returned and so this should
      be checked before trying to do anything with the "el" variable.`
    ]),
    // qItem('08', 'Run-time errors are encoded at the type level and handled as normal values', 'error-types', [
    //   `In some languages such as Java, errors are represented as "exceptions"
    //   that are thrown and must be caught to prevent the program from crashing.
    //   In other languages however, errors are represented as values like any
    //   other and can be manipulated and passed around as normal.`,
    //   `The Result type above demonstrates this. Instead of throwing an exception,
    //   the Result type describes a computation that might fail, and forces the
    //   developer to handle both cases whenever validating a month number.`
    // ]),
    qItem('09', 'The language supports code macros', 'macros', [
      `Some languages support macros as a means of generating or inserting
      bits of code into an existing piece of code. The code snippet is
      an example of a macro in C. When the compiler comes across any instances
      of the word "double", it expands and inserts the macro into the source
      code and then compiles that new piece of code instead.`,
      `Lisp takes this concept even further, allowing lisp programs themselves
      to manipulate macros, and so functions can be written to generate macros
      at run-time.`
    ]),
    // qItem('10', 'The language supports reflection and/or introspection', 'reflection-and-introspection', [
    //   `Languages that support reflection and/or introspection are capable of
    //   examining a program at run-time. In doing so, these programs are able to
    //   modify their own structure or behaviour, defining new types and inspecting
    //   the type or properties of values at run-time.`,
    //   `The above Java snippet gets all the methods defined in MyClass, and
    //   prints their names to the console. Reflection is particularly useful for
    //   serialising objects into a format such as JSON.`
    // ]),
    qItem('11', 'The language has a comprehensive standard library covering areas such as UI, graphics, networking, and more complex audio constructs', '', [
      `The language provides packages or modules for a wide variety of programming
      tasks as part of it's standard library.`,
      `These could include packages for creating and displaying user interfaces,
      handling network requests, drawing graphics to the screen, or higher-level
      audio elements such as complete synthesisers.`
    ]),
    qItem('12', 'Public packages must following the Semantic Versioning standard', 'semantic-versioning', [
      `Some languages have tighter control on their package ecosystem. Elm uses
      it's type system to analyse updates to packages and automatically works
      out how to bump the package version.`,
      `Semantic Versioning is a versioning standard that splits splits software
      versions into MAJOR.MINOR.PATCH numbers such as 1.1.0. This serves as a
      "contract" to consumers of a package, meaning that changes to a package's
      API must result in a MAJOR version increase.`
    ]),
    qItem('13', 'The ability to evaluate strings as source code at run-time', 'eval', [
      `In many interpretted languages (and some compiled ones), developers are
      given the ability to evaluate a string as though it were source code.`,
      `This can be useful for allowing user input to be run and executed as code
      or for code to be easily be dynamically generated and evaluated at run-time.`,
      `The code snippet shows the eval function in JavaScript. First, eval is
      called to evluate the result of 2 * 20, and that result can be stored in
      the x variable like normal. Notice how the second use of eval is able to
      use existing variables, here x is being converted to a string and assigned
      to y.`
    ]),
    qItem('14', 'Code testing is built into the language', 'first-class-tests', [
      `Testing code can be an important part of some developers workflow. It
      commonly involves testing a particular function or piece of code against
      a variety of different inputs and making sure the output is what was
      expected.`,
      `Various testing frameworks existing for many programming languages, but
      some offer specific constructs for testing as part of the language itself.`,
      `The code snippet is from the Pyret language. A simple double function is
      defined using the "fun" keyword, but then two test cases are defined after
      the "where" keyword. When the program is run, the test cases are evaluated
      and an exception is thrown if the result does not match the expected output.`
    ]),
    // qItem('15', 'Public packages must be fully documented before they are published', 'documentation', [
    //   `In many languages it is a common convention to have special documentation
    //   comments, such as the popular JavaDoc style, to provide structured
    //   documentation for a function or package.`,
    //   `Some package repositories require the presence of these special comments
    //   in any exposed function or class to help developers and consumers of the
    //   package.`
    // ]),
    qItem('16', 'The language has an online editor or playground', 'online-editor', [
      `An online editor or playground allows developers to experiment with the
      language without downloading anything or setting up any tooling.`,
      `It can also serve as a convinient scratchpad to quickly test ideas without
      the bloat of a full editor or ide.`
    ]),
    qItem('17', 'There is an official formatter that formats source code to conform with a fixed style guide', '', [
      `It is not uncommon for there to be differing opinions among developers
      around how source code should be written and formatted. So-called linters
      exist to enforce a specific code style within a team or community.`,
      `Recently, languages have started provided official linters so that the
      entire community conforms to a single style guide. This can be seen in
      languages such as Go, Rust, and Elm.`
    ]),
    qItem('18', 'Programs can be constructed in a visual patcher environment', 'visual-patcher', [
      `Some languages are visual rather than textual. Individual objects or
      functions are connected together with wires in a visual "patcher" environment
      that displays the flow of data in the program.`
    ]),
    qItem('19', 'There is an explorer for common and/or useful snippets of code, objects, or functions', 'explorer', [
      `It is common for similar code snippets and patterns to be repeated
      throughout a codebase, or across many codebases. A code snippet explorer
      can help managage the smaller pieces of code, particularly in cases
      where they tackle a specific or niche problem but the developer does not
      want to create or find a package to import.`,
      `For programming languages that also provide their own editor or environment,
      such a code snippet explorer might be included. It may also be possible
      to share snippets with the community and search for others.`
    ]),
    qItem('20', 'Functions and packages can be searched for based on their type signature', 'type-search', [
      `When a language has static typing, it opens up the possibility for a
      codebase or package to be searched for based not just on names but on
      type signatures as well.`,
      `Hoogle is one such example of this functionality. This can prove particularly
      useful when developers know the result they want to achieve but not the
      name of the function or want to explore different implementations with
      the same type signature.`
    ]),
    // qItem('21', 'There is an official linter that detects common problems and anti-patterns such as unused imports or duplicate variable names', 'linter', [
    //   `A linter is a tool that detects bad practices, ineffecient code, or
    //   common anti-patterns, and suggests how to fix those issues. These tools
    //   are often maintained by the community and are configurable to taste.`,
    //   `Some languages, however, include an official linter as part of the
    //   language distribution such as with Go. The benefit of such a linter is
    //   that they are often not user-configurable, ensuring the entire community
    //   is often adhering to the same standards and practices.`
    // ]),
    qItem('22', 'User interfaces can be built using a drag-and-drop editor', 'gui-editor', [
      `Some may find developing more complex user interfaces through plain
      code cumbersome or difficult to manage. As an alternative, a number of
      graphical editors exist to allow interface elements to be arranged on
      a canvas and have the necessary code generated afterwards.`
    ]),
    qItem('23', 'All values are immutable and cannot be modified', '', [
      `In languages such as Haskell or Elm, values cannot be changed after being
      defined. This means a suite of bugs related to mutating variables are no
      longer a problem, but also means that new variables must be created whenever
      we need to change something.`
    ]),
    qItem('24', 'Functions are pure and do not perform side effects', 'pure-functions', [
      `Pure functions exhibit two key properties. The first is known as referential
      transparency. This means that given the same input, the output is always
      the same. The second is a guarantee that the function has no side effects
      such as mutating variables or file I/O.`,
      `The code snippet contrasts a pure function to an impure one. The double
      function behaves predictably and consistenly, but the addRandom function
      does not. It mutates a global y variable, and uses Math.random meaning
      the return value can change even when the arguments stay the same.`
    ]),
    // qItem('25', 'Functions are first-class values and can be stored in variables and passed as arguments to other functions', 'first-class-functions', [
    //   `First-class functions means that functions are not treated as a special
    //   language construct or data type. They can be passed to other functions
    //   or stored in variables, arrays, etc.`,
    //   `The code snippet shows a function being used as an argument to the
    //   Array.map method. Array.map will then call that function on every element
    //   in the array to transform it.`
    // ]),
    qItem('26', 'Variable names cannot be shadowed', 'shadowing', [
      `Shadowing refers to the practice of creating a new variable with the
      same name as another variable in the outer scope. This can be convinient
      when shadowing generic variable names such as "x" in the code snippet, but
      can also make code more difficult to read as developers must have to
      remember which "x" is available in the current scope.`
    ]),
    // qItem('27', 'The language supports objects with local properties and methods', 'objects', [
    //   `In object-oriented programming, a particular domain is modelled around
    //   objects which contain some local state and some methods to manipulate
    //   that state. This is principally a way of controlling encapsulation: certain
    //   properties or state can be hidden and made accessible or modifiable via
    //   an object's methods.`
    // ]),
    qItem('28', 'The language enforces a specific type of application structure or architecture', '', [
      `There are many different ways to architecture and structure an applications.
      Some languages take a more opinionated approach and impose a particular
      architecture, or the language design makes a particular structure easier
      to adopt.`,
      `The code snippet shows a simple Csound program. All programs must have a
      <CsInstruments> tag and a <CsScore> tag, even if they are left empty.`,
      `This can be a benefit to a community as it becomes easier to read other
      people's code, but can also pose unhelpful restrictions when a developer
      wants to do something discouraged or outright impossible.`
    ]),
    qItem('29', 'A program can be edited while it is running and changes are reflected in real-time', '', [
      `Known as hot reloading, or hot module replacemenet, this technology allows
      a program to be edited while it is running without restarting the entire
      application.`,
      `This is particularly prevalent in web development, where it is often
      desireable to persist application state while changing UI or design
      elements.`
    ]),
    qItem('30', 'There is a foreign function interface (FFI) to call functions written in different languages', '', [
      `Some languages have a special ability to call functions or even import types
      and data structures from a separate language. Most commonly, languages have
      an FFI for calling C code to give developers access to high performance code
      when they need it.`,
      `This isn't the only use for an FFI, however. For languages built on a common
      platform, an FFI can allow those languages to share code and data structures
      as is the case in .NET languages like C#, F#, and BASIC.`
    ]),
    // qItem('31', 'Functions can be partially applied by supplying on some of it\'s arguments', 'partial-application', [
    //   `Partial application makes it easy to create new functions by supplying only
    //   some of the arguments to an existing function.`,
    //   `The code snippet shows the definition of an add function, and then a new
    //   add10 function being created by only supplying on argument to that add
    //   function.`
    // ]),
    qItem('32', 'The language has a different syntax for different parts of a program', 'different-syntax', [
      `Instead of keeping the same syntax for all parts of a program, some languages
      attempt to have different syntax (and sometimes semantics) more specifically
      tailored to each part.`,
      `The code snippet is a simple example from Csound. Different parts of the
      program are encapsulated in XML-style tags, and each have their own unique
      sytnax. The CsScore is wildly different from the CsInstruments section, for
      example, but both benefit from being specifically designed for that part of
      the program.`
    ]),
    // qItem('33', 'Compiler errors have a specific error code associated with them that can be used to find out more information about a particular error', 'error-codes', [
    //   `Sometimes a compiler or run-time error can have an explanation or additional
    //   information that is not practical to print to the terminal/console. In those
    //   cases the language might provide a specific error code that can be looked up
    //   in the language's reference for more information.`,
    //   `The image shows an example from Rust's error code reference, in this case
    //   the error code is E00299. It features an explanation on how the error is
    //   produced and a code example to exemplify that.`
    // ]),
    qItem('34', 'The compiler provides suggestions on how to fix a compiler error', 'compiler-suggestions', [
      `Some languages are able to offer suggestions or provide a more detailed
      error message during compile or run-time errors. When done well they can
      help developers quickly fix broken code or identify issues.`,
      `The image is an example from a compiler error thrown by the Elm programming
      language; notice how it provides the important information (there is a type
      mismatch between string and number), but also recognises that the wrong
      operator may have been used as instea.`
    ]),
    qItem('35', 'Compiler errors link directly to the portion of source code that caused the error', '', [
      `For languages with their own editors or good integration with existing editors,
      it can be possible to jump straight to error-producing code from an error
      message itself.`,
      `This can save developers time by not having to hunt around their codebase,
      particular when there are many files or lots of lines of code.`
    ]),
    qItem('36', 'Code can be compiled in a debug mode that allows events to be rewound and stepped through in time', 'time-travel', [
      `It is not uncommon for a language to offer a debugger that allows deevelopers
      to place break points to pause code execution and inspect the current program
      state. For applications that rely on user interaction, another type of debugger
      exists that records interaction events and allows them to be rewound and
      played back.`
    ])
  ].shuffle()
}
