require 'spec_helper'

describe ResourceInstancesListReport do
  let(:repo)  { Repository.create_from_json(JSONModel(:repository).from_hash(:repo_code => "TESTREPO",
                                                                      :name => "My new test repository")) }
  let(:datab) { Sequel.connect(AppConfig[:db_url]) }
  let(:res_deacc_job) { Job.create_from_json(build(:json_resource_deacc_job),
                       :repo_id => repo.id,
                       :user => create_nobody_user) }
  let(:report) { ResourceInstancesListReport.new({:repo_id => repo.id},
                                res_deacc_job,
                                datab) }
  it 'returns the correct fields for the resource instances list report' do
    expect(report.query.first.keys.length).to eq(7)
    expect(report.query.first).to have_key(:resourceId)
    expect(report.query.first).to have_key(:repo_id)
    expect(report.query.first).to have_key(:title)
    expect(report.query.first).to have_key(:resourceIdentifier)
    expect(report.query.first).to have_key(:level)
    expect(report.query.first).to have_key(:dateExpression)
    expect(report.query.first).to have_key(:extentNumber)
  end
  it 'has the correct template name' do
    expect(report.template).to eq('resource_instances_list_report.erb')
  end
  it 'renders the expected report' do
    rend = ReportErbRenderer.new(report,{})
    expect(rend.render(report.template)).to include('Resources and Instances List')
    expect(rend.render(report.template)).to include('resource_instances_subreport.erb')
  end
end