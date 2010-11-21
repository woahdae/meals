@iphone
Feature: Mobile user browsing the site

  As a user on a mobile device
  I want to look up foods and add them to my list  
  So that I can shop on-the-go

  Background:
      And There are existing usda_ndb_foods with:
        | name         | kcal |
        | Noodles, dry | 138  |

  Scenario: I see foods from the foods page
       When I go to browse the food items
       Then I should see "Noodles, dry"

  Scenario: I search the foods
      Given There are existing foods with:
          | name       |
          | Fish, red  |
          | Fish, blue |
       When I go to browse the food items
        And I fill in "name" with "Fish, red"
        And I press "Search"
       Then I should see "Fish, red" within "#list"
        And I should not see "Sheep, blue" within "#list"
      
