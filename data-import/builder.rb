data = []
data = JSON.load(File.read("/Users/bumishness/Documents/Zooniverse/Chimp-Zoo/data-import/manifest.json")); nil

project = Project.where(name: 'chimp').first || Project.create({
  _id: BSON::ObjectId('5490b536edf8779a91000001'),
  name: 'chimp',
  display_name: 'Chimps',
  workflow_name: 'chimp'
})

workflow = project.workflows.first || Workflow.create({
  _id: BSON::ObjectId('5490b53bedf8779a91000002'),
  project_id: project.id,
  primary: true,
  name: 'chimp',
  description: 'chimp',
  entities: []
})

# For the moment, this nukes the current subject pool
ChimpSubject.destroy_all
redis = ChimpSubject.redis_set.redis
begin
  redis.keys('chimp*').each{ |key| redis.del key }
rescue
  puts "Redis isn't available"
end

data.each.with_index do |hash, index|
  puts "#{ index + 1 } / #{ data.length }"
  id = BSON::ObjectId(hash['id'])
  
  ChimpSubject.create({
    _id: id,
    project_id: project.id,
    workflow_ids: [workflow.id],
    coords: [],
    location: hash['location'],
    metadata: hash['metadata']
  }) unless ChimpSubject.where(_id: id).exists?
end

begin
  SubjectImporter.perform_async 'ChimpSubject'
rescue
  puts "Redis isn't available"
end
