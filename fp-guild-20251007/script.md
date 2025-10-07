```bash
ghci
```
- Hi everyone, it's me, one of your most Brisbane-based FP Guild Organisers. With the requirement to present at FP Guild to receive a t-shirt, I figured it is about time I give my first actually prepared FP guild talk. And I think that's probably our earliest shout out for FP Guild shirts as well, so I'm already smashing it.

- What I've aimed for today is a beginner talk for functional programming.
- We're going to be working with higher-order functions, and my goal is split, I want to either teach everyone here exactly what higher-order functions are and why they're great, or be so fundamentally wrong that people more knowledgeable than me will explain it to me. Either way someone will be learning something.

- As always, please ask any questions you want in the chat, but chances are I'll be in a fugue state and I'll miss it. I'll try my best, but feel free to interrupt me with any questions, concerns, corrections, or anything you want.


- So the first question is "What is a higher-order function?" It's a pretty fundamental question to this whole talk.
**SCROLL DOWN**
- Fortunately for me, they are pretty basic on paper. A higher-order function is any function that either takes a function as an argument, or returns a function. That's it, part one of the talk complete.

### Part 1

- Let's try to understand this with an example. It's one of the oldest uses of a higher-order function (citation needed), given a symbol by Euler in 1755, it's summation.
**SCROLL DOWN**
- Our first step in understanding higher-order functions is recognising that they are not an original concept to programming, like a lot of functional programming concepts, higher-order functions come to us from our friends in the world of mathematics.
- So let's walk through the definition of summation here. We have a series of numbers represented by $n$, ranging from the start index $a$ to the end index $b$ inclusive, and we want to apply a function $f$ to them and them sum them all together.
**SCROLL DOWN (a little)**
- For a more specific example, our function $f$ could be squaring the numbers from $1$ to $4$. The important take away from this is that we have a function, summation, and one of the arguments to summation is the function $f$. That's a higher-order function, baby.

- This is a pretty big deal in the world of mathematics, being able to condense a much larger problem into a pretty manageable definition.
**SCROLL DOWN**
- Smash cut to the 1958, John McCarthy has just started working on a new programming language, Lisp. Previous programming languages were not able to model several ideas in mathematics, such as recursion, conditionals, and our good friends, higher-order functions.
- Given we have such a strong debt to Lisp, we are going to look at our first programming example of higher order functions in-
**SCROLL DOWN**
- -Haskell.

- For those of you who don't appreciate a classic bait-and-switch and/or don't know Haskell, we're starting really basic and we are going to directly translate our summation from earlier, which should give you a pretty basic understanding of the language.


**Swap to code**
- We'll start by defining a squaring function. Let's write our function first, we have our function name, the input variables, and then the body of the function itself. In Haskell, we also have to signify the types, so we add in a type signature which indicates that our function takes one variable of type `a`, and returns a different variable of the same type, But not every variable can be exponentiated, so we need to stipulate that our variables of type `a` are both from the type class `Num`. Any number in Haskell belongs to this typeclass, and all types that inherit `Num` will be able to be added together, multiplied, or, in our case, exponentiated.
```haskell
square :: Num a => a -> a
square a = a^2
```
- Next, let's make our slightly more complicated summation function. Let's start from the body again.
- Our summation is going to take a function, $f$, a start index $a$, and an end index, . Let's do some basic recursion, if our start index is greater than our end index, we'll return $0$, else we want to apply our function $f$ to our current index, and then add that to the smaller summation of $a+1$ to $b$.
- Now let's work on our type signature, we know we are going to have to use our `Num` type signature again, due to using addition. What we will also need is the `Ord` typeclass, because we know $a$ and $b$ must be orderable to be able to check if $a$ is greater than $b$. Fortunately all numbers are orderable, so that's not asking much.
- Our variables are going to be a function that converts an $a$ to an $a$, and then 2 more variables of type $a$, and finally it will return a variable of type $a$.
```haskell
summation :: (Num a, Ord a) => (a -> a) -> a -> a -> a
summation f a b = if a > b
                  then 0
                  else f(a) + summation f (a + 1) b
```
- Okay, let's try it out. If we apply summation using our square function and the numbers 1 and 4, we should get 30. Hooray.
```haskell
summation square 1 4
```

- Well that's great, but why not just make a function that adds all the squares and not worry about passing in a function? This way we don't need to define two seperate functions.
```haskell
summationSquare :: (Num a, Ord a) => (a -> a) -> a -> a -> a
summationSquare f a b = if a > b
                        then 0
                        else (a^2) + summation f (a + 1) b
```
- Ignoring the FP principles of making atomic functions, we lose a lot of flexibility if we do this. We can define a couple of new functions, `identity` and `cube`.
```haskell
identity :: a -> a
identity a = a

cube :: (Num a) => a -> a
cube a = a ^ 3
```
```haskell
summation identity 1 4
summation cube 1 4
```
- And we can now use `summation` with both of these new functions without having to replicate all the logic of adding the values all up, where our `summationSquare` function languishes being able to do only one thing.

**Quick sojourn back to Excalidraw**
- Not relavent to that talk at all, but I noticed that while doing this that sum of cubes from $a$ to $b$ is the same as the squared sum of $a$ to $b$. I tried doing a proof this morning to add to the talk, but I am dumb, and didn't know about all this consecutive odd numbers stuff, which is pretty critical to the proof.
**Back to Haskell**

- Anyway! We've made it out of our first worked example with Haskell, and hopefully we are starting to understand what is so great about higher-order functions. They allow us to compose our functions together, minimising the work we have to do.


- Now, we can do summation, but what if we wanted to take it a step further? What if we wanted to subtract a series of numbers, or multiply them together?
- There are a lot of options that our summation doesn't cover, but we can think of summation as a special form of some higher-order functions we might already use in our day-to-day. Introducing, `foldr` and `foldl`.
```haskell
:t foldl
```
- I'm not going to get into the semantics of what is different about the two folds here, but given we are going to work with summation, which is associative, suffice to say that the way the `fold`s works is that it takes a function that combines two pieces of data, a starting variable of type `b`, a series of variables of type `a`, and then returns a result of type `b`.
- This is a more generic form of our summation, allowing us to do anything to join two pieces of data together. Let's rewrite our summation using `foldl` to get an idea of what it looks like.
```haskell
summationFold :: (Num a, Enum a) => (a -> a) -> a -> a -> a
summationFold f a b = foldl (\acc x -> acc + f(x)) 0 [a..b]
```
- We are going to copy our old function first, let's rename it while we're at it. Now let's mess with the body for a bit. We are going to use our new `foldl` function, it's first variable is a transformation function, so let's define an anonymous function that takes an accumulator and a varable, and adds the transformed variable to the accumulator.
- Next up, we are going to give it a starting value of 0, and then it is expecting a collection of numbers. To accomplish this, we will use a range, which gives us all the numbers from a to b, inclusive.
- This means we no longer have to be orderable, but we will have to be enumerable. So let's change up the type signature accordingly.

- Now we can use `summationFold` exactly like we did with summation. Unfortunately, we have been forced, against our will, to redefine addition here to include using the function over x. But don't worry, we can clean this up with another, even more widely used higher-order function! Let's chat about `map`.
```
:t map
```
- `map`, for those unaware, takes a function that converts a variable from type `a` to type `b`, a collection of variables of type `a` and returns a collection of variables of type `b`. This is exactly what we want for our summation, as we want to apply a function over each variable, so let's rewrite our `summation` one last time.
```haskell
summationHigher :: (Num a, Enum a) => (a -> a) -> a -> a -> a
summationHigher f a b = foldl (+) 0 (map f [a..b])
```
- We'll copy-paste again, and we'll start by mapping our input variables. We pass in our function `f`, and voila, we have a collection all the numbers from `a` to `b`, with the function `f` applied.
- After that, we can remove our anonymous function, and replace it with a simple addition.
- What we have left is a nice, neat function, and you can fight me on that. We can see here that we can compose higher-order functions together to produce quite complex results.
- There might be a concern that we are iterating over the same list of numbers twice, once to apply the function and again to collect it all together. This is not a concern in Haskell, as map is lazily evaluated, which means the function isn't actually applied until we are collecting it.

- How are we feeling? Pumped up? Jazzed? Excited for more Haskell? All of the above? I'm afraid those are our only four options, so just pick whatever is closest.

### Part 2

- Remember at the top our definition of higher-order functions? "Any function that either takes a function as an argument, or returns a function."
- We've been working through our first case, taking functions as arguments, but what about our second case, returning a function?
- What if I said we've been using them this whole time? Here is where I reveal my deceit. I've been lying to you about a core component of Haskell, either out of a desire to ease you in or our of complete and utter malice, I'll let you decide.

- The truth is, Haskell functions can only ever take 1 argument.
- When I first learned Haskell, this took me a while to understand, but the idea is this. I've been making these type signatures over here, and what I said and implied is that everything except the last item in that list is an input to our function, and then there is an output, but it is, in fact, the other way around.
- Our first item in our type signature is the only input, and the output is all the other pieces, which together are a function. Let's look at it in practice using our summation function.
```haskell
squareSum = summationHigher square
:t squareSum
```
- Let's create a new variable, `squareSum`, which is our `summationHigher` function, with the input function as our `square` function. We can check the type of this variable as see that it is a function with the type signature we would expect.
- What can we do with this? Well we can now use this returned function multiple times in quick succession, like so.
```haskell
squareSum 1 4
squareSum 5 20
squareSum (-4) (-1)
```
- What we have done here is generally known as partial application, and is a great way to pass things around cleanly if you're doing something in bulk. One great place to use these partially applied functions is in the `map` function we've already looked at.

- If we check the type signature for our `map` function again, we see that the input mutation function takes only 1 variable. I don't know about everyone else in the call, but I constantly want to include more variables in my map function.
- This is where our partially applied functions really shine. Let's look at a real world example in my company. In reality, this is all in Python, but switching language is a nightmare in a talk, so we'll replace it with Haskell.

**Swap back to Excalidraw**
- My team has a tool that decrypts a bunch of PII to send to some customers. To decrypt this PII, we send a whole bunch of requests to another team's decryption tool, which was only designed to take 1 row at a time as a request.
**Scroll down**
- To try to reduce the load on their service, we added a hash of the encrypted file's contents to our output, and we read the previous day's output file to see if we can skip any of those decryption calls.

**Back to Code, swap to workExample.hs**
- I've prepped some of this code already, so we don't anger the live demo gods too much. First up, we have two dataclasses. They are just ways to easily pass around data. We have some `PiiData` which is just an id and a name, and then a hashed variant.
- Next we define equality for our hashed data, which is just that the hashes are equal. After that, we have a function, `hashPii`, that hashes our `PiiData`, to turn it into `HashedPiiData`. For our purposes, it is just based on the length of the string.
- Lastly, I've added in two lists of data, some encrypted data and some decrypted data.
- We can see that our first 3 elements will match each other, but the last one has different string lengths and will not.

- These are almost all the tools we need for this demo. Honestly, it's a bit more than we need, but I wanted to use at least one company-specific example instead of something arbitrary.
- What we first need to do is have some function that retrieves an item from our array if it is a match. Let's define a function `retrieveFromCache`. We know it will take a collection of (decrypted) `HashedPiiData`, a encrypted `HashedPiiData`, and return a `HashedPiiData`.
- Next up, in the body, we are going to use probably my favorite part of Haskell, which is pattern matching. Pattern matching exists in other languages, but Haskell's is the nicest I've worked with.
- So let's define our first case, which is when we have an empty array. In this case, we know our variable a doesn't exist and we can just return it. In reality, this is where we would send it off to get decrypted.
- Our other case is when we have data in our cache, which has a head, `c`, and a tail, `cs`. In this case, we will use a case statement to check if our variable `a` matches `c`. If it does, return the element from the cache, otherwise, recursively call this function with the remaining elements of our collection.
```haskell
retrieveFromCache :: [HashedPiiData] -> HashedPiiData -> HashedPiiData
retrieveFromCache [] a = a  -- Send to decryption service
retrieveFromCache (c:cs) a
    |c == a = c
    |otherwise = retrieveFromCache cs a
```

- Now let's talk about what we have and what we are trying to do. We want to iterate over all our encrypted data, and we want to check if we already have decrypted it. If we have, we just want to return that data.
```haskell
map retrieveFromCache encryptedPiiData
```
- This function doesn't work because `map` will only accept a function that takes 1 argument. To get around this, we need to partially apply our `retrieveFromCache` function, using the `decryptedPiiData`.
```haskell
decryptFromCache = retrieveFromCache decryptedPiiData
```

And now that we have that, we can check it's type.
```haskell
:t decryptFromCache
```
and we can see that signature lines up well with map. So now we map over our data like so
```haskell
map decryptFromCache encryptedPiiData
```
which we'll see has decrypted our data, woooo!

### Part 3

- Congratulations if you've stuck with me to now, even I got bored during that segment.
- Everyone who switched off the moment I started talking about company-specific code, you can come back in, because there is one more example of a function that returns another function I could think about off the top of my head, which is the decorator pattern.

**Back to excalidraw**
- The basic idea is that you define a function $B$ that takes, as an argument, another function $A$. $B$ then returns a new function, which will wrap our function $A$ in some other code. The classic example is timing the function to check performance. This new function will mimic the type signature of the argument function, meaning you can use it in all the same places.

- The typical use for these functions is to perform some side effect with your function call, which, if possible to do in Haskell, is beyond my understanding. So we'll do something a little bit different to emphasis the idea.

- This last segment of the talk will feature a bit of maths, which might not excite too many people, but it will culminate with talking about physics engines in games, so hopefully that is a nice carrot to keep you engaged.
- It's time to talk about polynomials, differentials, and integrals in cartesian space. For those playing at home, a polynomial function is one that takes an $x$, a coefficient $a$, an exponent $b$, and a constant $c$. In our example on the side here, we can see an example of a polynomial on a cartesian plane.
**Scroll Down**
- A differential is a function that operates over a polynomial, reducing the exponent by 1 and multiplying the coefficient by the original value of the exponent. This is used to calculate the rate of change. In our example on the side, this is just the gradient of our original line. For examples in physics, acceleration is the rate of change of velocity, which is, in turn, the rate of change of displacement.
**Scroll Down**
- An integral is the opposite of that, where you are increasing the exponent by 1, and dividing the coefficient by the new exponent value, while adding in a new constant, $d$. This is commonly used in maths to calculate the area under the line. If we are looking at a graph of velocity, this would calculate how much distance we have travelled in that time.

**Back to code**
- Let's create polynomials, derivatives, and integration in Haskell.
- First we need to create the concept of a polynomial. A polynomial is just a function, so let's define it as such.
```haskell
polynomial :: (Fractional a, Integral b) => a -> b -> a -> a
polynomial a b x = a * x ^ b
```
- Haskell does not innately allow non-integral exponents, despite them being a real thing, but we'll just have to forgive it for that.

- Now that we have our polynomial function, let's create a differential. If our exponent is 0, our differential will return 0, otherwise, we are going to modify the polynomial as we discussed.
```haskell
differential :: (Fractional a, Integral b) => (a -> b -> a -> a) -> a -> b -> a -> a
differential _ _ 0 _ = 0
differential p a b x = p (a * (fromIntegral b)) (b - 1) x
```

- Now, let's talk about this, we are taking a function $p$ with the same type signature as polynomial, and then we are applying it to the same 3 arguments as polynomial. If we were to partially apply differential, our type signature would mimic polynomial's.
- In effect, we have wrapped the polynomial function, and returned another which some some magic before passing through to polynomial.

```haskell
diff = differential polynomial
:t diff
```
- When we worked with summation, we used a higher-order function to make it generic, but here we are using a differential function which can only ever be applied to a polynomial, why not just make differential call polynomial directly? We'll get to that, don't worry.
- Here we can forget all about differentials and work on integration. If we were using dataclasses, we could add in the idea of a constant, but let's ignore that for now so I can make my point.
```haskell
integral :: (Fractional a, Integral b) => (a -> b -> a -> a) -> a -> b -> a -> a
integral p a b x = p (a / (fromIntegral newB)) newB x
    where newB = b + 1
```
- The `where` clause I've added here allows us to create named, internal functions in our code. Here we use it just to make the method a little more readable.

**Back to excalidraw**
- Now that we have those, let's discuss why we are going to need them. Typically, the information stored in a physics engine is a value for velocity and a position. Each physics process, the position moves in the direction of velocity multiplied by the delta time between the last physics process and this one.
- This is great if you have a constant velocity, but when you add acceleration to the mix, this is an imprecise way to calculate how something moves, and is dependant on how many physics frames you are running at. I've demonstrated here an example of a lower and higher delta time between physics processes to show why this matters.

- Let's make this precise. To do that, let's go over the maths. We know that acceleration is the derivative of velocity, which is the derivative of displacement, which, in physics, is denoted by an $s$. Inversely, displacement is the integral of velocity, which is the integral of acceleration.
- Assuming we have a constant acceleration, we know that displacement is the integral of velocity.
- We also know that velocity is the integral of acceleration.
- We can think of acceleration as being multiplied by time to the power of 0. When we integrate it, that exponent of becomes 1, we divide by the new exponent, and we add a constant, which gets us to $at+u$, where $u$ is the symbol for initial velocity in physics.
- Going through the same process, we increase all our exponents by 1, divide by the new exponents, and add a constant, in this case, $s_0$, our displacement when $t=0$.
- The integral of velocity, therefore, is $\frac{1}{2}at^2+ut+s_0$.

- So here we have the actual velocity of a jump, a nice, smooth, curve, completely independent of the speed of the physics processes. In this example, our acceleration is the force of gravity, our initial velocity is a monstrous 10m/s jump, and we are starting on the ground.

- Let's recreate this in Haskell, and show our higher-order functions in practice.
**Back to Haskell**
```haskell
data Character a u s = Character a u s
    deriving Show
character = Character (-9.8) 10.0 0.0

moveCharacter :: Fractional a => a -> Character a a a -> Character a a a
moveCharacter t (Character a u s0) = Character a v s
    where v = u + integral polynomial a 0 t
          s = s0 + integral polynomial u 0 t + integral (integral polynomial) a 0 t
```
- I've got some definitions ready to go here. We have a character dataclass, with an initial character variable that has our initial state, we don't care too much about it, other than having it capable of showing us a result.
- Now we'll make a `moveCharacter` function which takes a character and a delta, and then returns a new character state.
- To do this, we are going to give our return character a new velocity $v$, and a new displacement $s$. We've just gone and manually calculated what we need, but here we can just pass our polynomial into our integral function.
- So for $v$, we want the integral of $a$, plus our initial velocity $u$. To avoid brackets, we are flipping the order, but fortunately, addition is commutative, so it doesn't matter.
- It gets a bit trickier for displacement, but this is where we finally pay off our promise earlier. We have our initial displacement, plus the integral of our initial velocity, plus the integral of the integral of acceleration.
- This is why we don't want our integrals or derivatives to just call the polynomial function directly, and why we are using higher-order functions in the first place, we can get the integral of an integral, because it returns a polynomial!

- To make sure we've done it correctly, we can test it out. Now if we load this up and call `moveCharacter`, we can see that after 1 second, our velocity is a floating point error away from 0.2, and we have jumped 5.1m into the air, which is a hell of a jump. But more importantly, this is exactly what we were expecting.
```haskell
moveCharacter 1 character
```
- We can also break our equation down into smaller chunks and we should get the exact same result
```haskell
moveCharacter 0.5 $ moveCharacter 0.5 character
```
- Which shows us that not only is this correct for any value of $t$, it is also correct for any initial state. Woohoo!

- Woowee, hopefully that was a fun bit of learning all round, we had some FP, some Haskell, some maths, and I even got a rant about physics engines in there. Let's summarise what we've learned
    - Higher order functions are functions that either accept a function as an argument or return a function
    - In general, they are really cool, flexible, and very powerful for generalising work
    - Maths is fun
    - Haskell should be in Adopt