Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

# Example

# class Person
#   constructor: (@firstName, @lastName) ->
#   @property 'fullName',
#     get: -> "#{@firstName} #{@lastName}"
#     set: (name) -> [@firstName, @lastName] = name.split ' '

# p = new Person 'Robert', 'Paulson'
# console.log p.fullName # Robert Paulson
# p.fullName = 'Space Monkey'
# console.log p.lastName # Monkey
