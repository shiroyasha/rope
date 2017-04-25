require "spec_helper"

describe Rope::Service do
  subject(:service) { described_class.new(File.join(File.dirname(__FILE__), "service.yml")) }

  it { expect(service.name).to eq("events") }

  describe "models" do
    it { expect(service.models).to all( be_instance_of(Rope::Service::Model) ) }
    it { expect(service.models.count).to eq(1) }

    subject(:model) { service.models.first }

    it { expect(model.name).to eq("event") }

    describe "fields" do
      it { expect(model.fields.count).to eq(2) }
      it { expect(model.fields).to all( be_instance_of(Rope::Service::Model::Field) ) }

      it { expect(model.fields[0].name).to eq("name") }
      it { expect(model.fields[0].type).to eq("string") }
      it { expect(model.fields[1].name).to eq("created_at") }
      it { expect(model.fields[1].type).to eq("int") }
    end
  end

  describe "interface" do
    subject(:interface) { service.interface }

    it { is_expected.to be_instance_of(Rope::Service::Interface) }

    describe "actions" do
      it { expect(interface.actions).to all( be_instance_of(Rope::Service::Interface::Action) ) }
      it { expect(interface.actions.size).to eq(3) }

      it { expect(interface.actions[0]).to be_async }
      it { expect(interface.actions[1]).to_not be_async }
      it { expect(interface.actions[2]).to_not be_async }

      it { expect(interface.actions[0].args).to all( be_instance_of(Rope::Service::Interface::Action::Arg) ) }
      it { expect(interface.actions[0].response).to be_instance_of(Rope::Service::Interface::Action::Response) }
    end
  end
end
