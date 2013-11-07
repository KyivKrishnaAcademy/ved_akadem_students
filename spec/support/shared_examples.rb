shared_examples_for "have DB column of type" do
  it { should have_db_column(name).of_type(type) }
end
