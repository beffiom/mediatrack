# minimal baseline data; safe to run multiple times

if Rails.env.development?
  # demo user
  user = User.find_or_create_by!(email: "demo@example.com") do |u|
    u.password = "password123"
    u.password_confirmation = "password123"
  end

  samples = [
    { tmdb_id: 603, title: "the matrix", media_type: "movie", poster_path: "/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg", release_date: Date.new(1999,3,31) },
    { tmdb_id: 1399, title: "game of thrones", media_type: "tv", poster_path: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg", release_date: Date.new(2011,4,17) },
    { tmdb_id: 5114, title: "fullmetal alchemist: brotherhood", media_type: "tv", poster_path: "/5ZFUEOULaVml7pquY4M6cJrz4J9.jpg", release_date: Date.new(2009,4,5) }
  ]

  samples.each do |attrs|
    media = MediaItem.find_or_create_by!(tmdb_id: attrs[:tmdb_id]) do |m|
      m.title = attrs[:title]
      m.media_type = attrs[:media_type]
      m.poster_path = attrs[:poster_path]
      m.release_date = attrs[:release_date]
    end

    WatchlistItem.find_or_create_by!(user: user, media_item: media) do |wi|
      wi.status = ["planned", "watched"].sample
      wi.watched_on = (wi.status == "watched" ? Date.today - rand(1..30) : nil)
    end
  end

  puts "seeded demo user and sample media items"
end
