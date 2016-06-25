require 'test_helper'

class ActiveParamsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ActiveParams::VERSION
  end

  def test_strong_params_definition_for_number
    assert_equal 123,
      ActiveParams.strong_params_definition_for(123)
  end

  def test_strong_params_definition_for_string
    assert_equal "123",
      ActiveParams.strong_params_definition_for("123")
  end

  def test_strong_params_definition_for_array
    assert_equal [],
      ActiveParams.strong_params_definition_for([123, "123"])
  end

  def test_strong_params_definition_for
    assert_equal [:id, :name, contacts: [:name, :relation, contacts: [:relation, :name], addresses: [:label, :address]], interests: []],
      ActiveParams.strong_params_definition_for({
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
