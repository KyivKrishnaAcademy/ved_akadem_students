job_type :exec, 'cd :path && :task :output'

every '5 0 1 * *' do
  exec 'backup perform -t monthly'
end

every '5 0 * * 1' do
  exec 'backup perform -t weekly'
end

every '5 0 * * *' do
  exec 'backup perform -t daily'
end
