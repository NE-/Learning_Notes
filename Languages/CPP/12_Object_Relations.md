<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 20
  Purpose: C++ Object Relations
-->

# Object Composition and Aggregation
## Composition
- Object composition is the building of a complex object from smaller, simpler objects.
- **"Part-of"** relationship.
- What relationship makes a composition:
  - Member belongs to the class.
  - Member belongs to only one class at a time (can't reuse the instantiated object outside the class).
  - Member is managed by the class (nothing outside can influence the member).
  - Member doesn't know about the entire class itself. The class knows about the member, but not the other way around (known as unidirectional relationship).
```cpp
// Part-of example
class Vec2D {
  private:
    double m_x{};
    double m_y{};
  public:
    Vec2D(double x=0, double y=0)
      : m_x{x}, m_y{y} {}

    double getX() const { return m_x; }
    double getY() const { return m_y; }
    
    void setX(double x) { m_x = x; }
    void setY(double y) { m_y = y; }
};

class Player {
  private:
    unsigned int id{0};
    Vec2D m_pos{}; // part-of Player
    ...
};

// Usage
Player p1 { 23, { 0, 0 } };
Player p2 { 24, { 12, 6.78 } };
```
## Aggregation
- Similar to composition, however, aggregation allows for parts to belong to more than one object at a time.
  - The object it belongs to isn't responsible for managing the part nor the lifespan of it.
- **"Has-a"** relationship.
- What relationship makes an aggregation:
  - Member belongs to the class.
  - Member can belong to more than one class at a time.
  - Member is not managed by the class.
  - Member doesn't know about the entire class itself (still unidirectional).
```cpp
// has-a example
class Employee {
  ...
};

class Company {
  private:
    // Company has-an employee
    const Employee& m_emp;

    public:
      Company(const Employee& emp)
        : m_emp{emp} {}
      
      const std::string_view& getEmployee() const {
        return m_emp.getName();
      }
};

// Usage
Employee john{ "John" };

{
  // Create company
  Company co{ john };
  std::cout << co.getEmployee();
} // Company no longer exists

std::cout << john.getName(); // Employee still exists
```
- To use an array of references use `std::reference_wrapper` defined in `<functional>`.
```cpp
std::vector<const Employee&> m_employees; // ERROR
std::vector<
  std::reference_wrapper<const Employee&>
> m_employees; // OK
```
# Association
- When one class uses another to get a job done. They are not a part of each other.
- **"Uses-a"** relationship.
- What relationship makes an association:
  - Member is unrelated to the class.
  - Member can belong to more than one class at a time.
  - Member is not managed by the class.
  - Member may or may not know about the existence of the class (can be uni- or bidirectional. This is how it differs from aggregation).
- Usually implemented with pointers, but depends on context.
```cpp
class Client {
  private:
    float m_money{};

  public:
    Client(float money=0) : m_money{money} {}

    float pay() {
      float temp = m_money;
      m_money = 0;

      return temp;
    }
};

class Shop {
  private:
    double m_income{0};

  public:
    Shop() = default;

    void makeSale(Client& client) {
      m_income += client.pay();
    }
};

// Usage
Shop aMart;
Shop bMart;

Client a{ 67 };
Client b{ 34 };
Client c{ 29 };
Client d{ 83 };

aMart.makeSale(a);
bMart.makeSale(d);
aMart.makeSale(c);
bMart.makeSale(a);
```

## Reflexive Association
- Same, just uses an object of the same type.
- This can lead to chaining of objects.
```cpp
class Course {
  private:
    std::string m_name{};
    const Course* m_prereq{};

  public:
    Course(const std::string& name, const Course* prereq=nullptr)
      : m_name{ name }, 
        m_prereq{ prereq } {}

    const std::string_view& getPrereq() const {
      return m_prereq->m_name;
    }

    void printAllPrereqs() {
      const Course* temp = m_prereq;

      while(temp) {
        std::cout << temp->m_name >> '\n';

        temp = temp->m_prereq;
      }
    }
};

// Usage
Course cs1{ "Intro to Comp Sci" };
Course cs2{ "Functional Programming", &cs1 };
Course cs3{ "OOP", &cs2 };
Course cs4{ "DS and Algo", &cs3 };
Course cs5{ "GUI", &cs4 };
Course cs6{ "AI", &cs5 };

/*
  Prints
  GUI
  DS and Algo
  OOP
  Functional Programming
  Intro to Comp Sci
 */
cs6.printAllPrereq();

/*
  Prints
  OOP
  Functional Programming
  Intro to Comp Sci
 */
cs4.getAllPrereq();
```

# Inherited Relationship
- One class is built upon the definitions of another.
- **"Is-a"** relationship.
- With derived classes, top-most base class is built first then goes down the "family tree;" destruction starts at the bottom-most child and goes up the "family tree."
- Inherited classes do not have access to parent's private members.
- Only parent constructors can be called from a child (no child nor grandparents).
```cpp
class Animal {
  private:
    std::string m_type{};
    std::string m_noise{};
    int m_nLegs{};
  
  public:
    Animal(const std::string& type="", const std::string& noise="", int legs=0)
      : m_type{type}, m_noise{noise}, m_nLegs{legs} {}

    int getLegs() const { return m_nLegs; } // Public shared to inherited classes
};

class Cat : public Animal {
  private:
    double m_jumpHeight{};
    int m_age{};

  public:
    Cat(const std::string& type="", const std::string& noise="", double jumpHt=0.0, int age=0) :
      Animal{ type, noise, 4 }, // Initialize members from parent class
      m_jumpHeight{ jumpHt },
      m_age{ age } {}

    int getAge() const { return m_age; } // Cat only
}

// Usage
Cat sam{ "Cat", "Meow", 2.6, 2 };
sam.getAge();
sam.getLegs(); // Legal, also belongs to inherited class
```
## Access Specifiers
- `public`: Anyone can access these members.
- `private`: The class itself and friends can access these members.
- `protected`: The class, friends, and derived classes have access to these members, nothing outside.
```cpp
class Base {
  private:
    int m_private{};
  public:
    int m_public{};
  protected:
    int m_protected{};
};

class Derived : public Base {
  public:
    Derived() {
      m_private   = 1; // ERROR only base class has access
      m_public    = 1; // OK anyone can access this
      m_protected = 1; // OK only base, derived, and friends have access
    }
};

Base base;
base.m_private   = 1; // ERROR
base.m_public    = 1; // OK
base.m_protected = 1; // ERROR no outside access permitted
```
- Protected members can be set to public or private with `using`.
- And members may be deleted to prevent their usage.
```cpp
class Base {
  public:
    int m_public{};
    void delme();
  protected:
    int m_protected{};
};

class Derived : public Base {
  private:
    using Base::m_public;
  public:
    using Base::m_protected;

    void delme() = delete; // Unusable even in this class
};

Derived d{};
d.m_protected = 1; // OK
d.m_public = 1;    // ERROR this is now private
d.delme();         // ERROR function is deleted
```
### Inheritance Access Specifiers
- Change member access rules of the parent to the child (only apply to the child).
- `public`: public = public, private = private, protected = protected.
- `private`: public = private, protected = private, private = private.
- `protected`: public = protected, protected = protected, private = private.

## Overriding Functions
- Ability to override a parent's function.
```cpp
class Parent {
  public:
    void talk() {
      std::cout << "Parent Talked\n";
    }
};

class Child : public Parent {
  public:
    void talk() {
      std::cout << "Child Talked\n";

      // If we need parent's talk()
      Parent::talk();
    }
};
```

# Container Classes
- Container classes are usually wrappers of other objects or types.
- Main purpose is to make a raw type easier and/or safer to use.
- Examples are `std::vector` and `std::array`.