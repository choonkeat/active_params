require 'test_helper'

class ActiveParams::ParserTest < Minitest::Test
  include ActiveParams::Parser

  def test_strong_params_definition_for_number
    assert_equal 123,
      strong_params_definition_for(123)
  end

  def test_strong_params_definition_for_string
    assert_equal "123",
      strong_params_definition_for("123")
  end

  def test_strong_params_definition_for_array
    assert_equal [],
      strong_params_definition_for([123, "123"])
  end

  def test_strong_params_definition_for
    assert_equal [:id, :name, contacts: [:name, :relation, contacts: [:relation, :name], addresses: [:label, :address]], interests: []],
      strong_params_definition_for({
        id: rand,
        name: "Lorem ipsum",
        contacts: {
          "0" => {
            relation: "Friend",
            name: "Bob",
          },
          "1" => {
            relation: "Mother",
            name: "Charlie",
            contacts: {
              "0" => {
                relation: "Friend",
                name: "David",
              },
              "1" => {
                relation: "Friend",
                name: "Ethan",
              },
            },
            addresses: [
              { label: "home", address: "123 Sesame Street, NY" },
              { label: "work", address: "Lorem ipsum"},
            ]
          },
        },
        interests: [
          "Running",
          "Netflix",
        ]
      })
  end
end
