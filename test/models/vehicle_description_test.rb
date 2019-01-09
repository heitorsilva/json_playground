class UserTest < ActiveSupport::TestCase
  test 'invalid' do
    v = Vehicle.new
    v.description.name = "abc"
    assert !v.save, "be invalid"
    assert v.errors.count == 1, "have one error"
  end

  test 'save and resurrect' do
    Vehicle.delete_all
    v = valid_vehicle("somename", "somebrand")
    assert v.save, "save successfully"

    w = Vehicle.first
    assert_equal w.description.name, "somename", "resurrect name correctly"
    assert_equal w.description.brand, "somebrand", "resurrect brand correctly"
  end

  test 'deal with a non-default schema' do
    # create a default vehicle to work with
    Vehicle.delete_all
    v_orig = valid_vehicle
    v_orig.save

    # change the schema (use a low-level call to inject a valid record)
    schema = { "required" => ["fish"], "attributes" => { "fish": { "type": "string", "default": "", "value": "" } } }
    raw_description = { "_schema" => schema, "fish" => "yummi" }
    v_orig.update_columns(description: raw_description)

    # assert that resurrecting the record works
    v_reread = Vehicle.first
    assert_equal v_reread.description._schema["required"], ["fish"], "not ignore schema"
    assert_equal v_reread.description.fish, "yummi", "resurrect fish correctly"

    # simulate update
    v_update = Vehicle.first
    params = { "description" => { "fish" => "muuuh" } }
    Description.enrich_params!(params, v_update)
    assert v_update.update(params), "update successfully"
    assert_equal v_update.description.fish, "muuuh", "have updated attribute"
  end

  protected

  def valid_vehicle(name="a", brand="b")
    v = Vehicle.new
    v.description.name = name
    v.description.brand = brand
    return v
  end
end
