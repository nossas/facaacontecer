require 'spec_helper'

describe SubscribersController do
  describe "POST #create" do
    let(:user)    { User.make! }
    let(:project) { Project.make! }
    let(:options) do
      {
        name:             "Juquinha da silva",
        birthday:         "1988/11/12",
        email:            "juquinha@zip.net",
        cpf:              11144477735,
        address_street:   "Rua Belisario Tavora 500",
        address_extra:    "Laranjeiras",
        address_number:   "100",
        address_district: "Laranjeiras",
        city:             "Rio de Janeiro",
        state:            "RJ",
        country:          "BRA",
        zipcode:          "78132-500",
        phone:            "(21) 97137471"
      }
    end
  end
end
