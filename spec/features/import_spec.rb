require 'spec_helper'

describe 'import', :type => :feature, :js => true do

  before :each do
    @store = Store.new
    Store.stub(:new).and_return(@store)
  end

  it "imports a valid CSV" do
    visit import_csv_admin_stores_path

    Admin::StoresController.any_instance.should_receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123'
                            })

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/basic.csv'))
  end

  it "alerts missing required fields" do
    visit import_csv_admin_stores_path

    Admin::StoresController.any_instance.should_not_receive(:update_row_resource)
    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/missing_required.csv'))
  end

  it "sends optional fields" do

    visit import_csv_admin_stores_path
    
    Admin::StoresController.any_instance.should_receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123',
                            'location' => 'Melbourne'
                            })

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/optional.csv'))
  end

end
