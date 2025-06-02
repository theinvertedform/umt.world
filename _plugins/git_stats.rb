module Jekyll
  class GitStatsGenerator < Generator
    def generate(site)
      site.data['git_stats'] = {}

      # Get commits by month with stats
      commits = `git log --pretty=format:"%ad" --date=format:"%Y-%m" --shortstat`

      current_month = nil

      commits.split("\n").each do |line|
        line = line.strip
        next if line.empty?

        # If line looks like a date (YYYY-MM format)
        if line.match(/^\d{4}-\d{2}$/)
          current_month = line
          site.data['git_stats'][current_month] ||= {
            'commit_count' => 0,
            'insertions' => 0,
            'deletions' => 0
          }
          site.data['git_stats'][current_month]['commit_count'] += 1

        # If line contains file changes stats
        elsif line.match(/\d+ files? changed/) && current_month
          # Parse: "2 files changed, 15 insertions(+), 8 deletions(-)"
          insertions = line.scan(/(\d+) insertions?\(\+\)/).flatten.first.to_i
          deletions = line.scan(/(\d+) deletions?\(\-\)/).flatten.first.to_i

          site.data['git_stats'][current_month]['insertions'] += insertions
          site.data['git_stats'][current_month]['deletions'] += deletions
        end
      end
    end
  end
end
