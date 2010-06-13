Feature: a user searches foods by name
  As a hungry user
  I want to search foods by name
  So that I can find foods quickly

  Background:
    Given I go to browse the food items

  Scenario: I successfully search foods by name
      Given There are existing user_foods with:
          | name       |
          | Fish, red  |
          | Fish, blue |
       When I fill in "name" with "Fish, red"
        And I press "Search"
       Then I should see "Fish, red" within "#foods_list"
        And I should not see "Sheep, blue" within "#foods_list"
