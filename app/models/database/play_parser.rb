module Database
  class PlayParser
    include BasketballReference
    def initialize(options)
      @options = options
      @game = options[:game]
      @players = options[:players]
      @player_stats = options[:player_stats]
      @on_court = options[:on_court]
      @play = options[:play]
      @player1 = options[:player1]
      @player2 = options[:player2]
      @player_stat1 = @player_stats[@player1]
      @player_stat2 = @player_stats[@player2]
      @time = options[:time]
      @quarter = options[:quarter]
    end

    def add_stats
      @on_court << @player1 if @player1 && @on_court.size != 10
      @on_court << @player2 if @player2 && @on_court.size != 10
      case @play
      when /Defensive rebound/
        def_reb
      when /Offensive rebound/
        off_reb
      when /free throw/
        @play.include?("miss") ? miss_free : make_free 
      when /misses 2-pt/
        miss_two
      when /misses 3-pt/
        miss_three
      when /makes 2-pt/
        make_two
      when /makes 3-pt/
        make_three
      when /Turnover/
        turnover
      when /enters the game/
        substitution
      when /Double personal/
        double_foul
      when /foul/
        personal_foul unless @play.include?('tech') || @play.include?('Tech')
      when /quarter/
        new_quarter
      when /overtime/
        new_quarter
      end
    end

    def def_reb
      @player_stat1[:drb] += 1 if @player_stat1
    end

    def off_reb
      @player_stat1[:orb] += 1 if @player_stat1
    end

    def miss_free
      @player_stat1[:fta] += 1
    end

    def make_free
      @player_stat1[:fta] += 1
      @player_stat1[:ftm] += 1
      @player_stat1[:pts] += 1
    end

    def miss_two
      @player_stat1[:fga] += 1
      @player_stat2[:blk] += 1 if @player_stat2
    end

    def make_two
      @player_stat1[:fga] += 1
      @player_stat1[:fgm] += 1
      @player_stat1[:pts] += 2
      @player_stat2[:ast] += 1 if @player_stat2
    end

    def miss_three
      @player_stat1[:fga] += 1
      @player_stat1[:thpa] += 1
      @player_stat2[:blk] += 1 if @player_stat2
    end

    def make_three
      @player_stat1[:fga] += 1
      @player_stat1[:fgm] += 1
      @player_stat1[:thpa] += 1 
      @player_stat1[:thpm] += 1
      @player_stat1[:pts] += 3
      @player_stat2[:ast] += 1 if @player_stat2
    end

    def turnover
      @player_stat1[:tov] += 1 if @player_stat1
      @player_stat2[:stl] += 1 if @player_stat2
    end

    def substitution
      @on_court.delete(@player2)
      @on_court << @player1

      @player_stat1[:time] = @time
      @player_stat2[:time] = period_minutes if @player_stat2[:time] == 0
      @player_stat2[:sp] += @player_stat2[:time] - @time
      @player_stat2[:time] = 0
    end

    def double_foul
      @player_stat1[:pf] += 1
      @player_stat2[:pf] += 1
    end

    def personal_foul
      @player_stat1[:pf] += 1 if @player_stat1
    end

    def new_quarter
      case @play
      when /Start of/
        @options[:quarter] += 1
        reset_minutes
      when /End of/
        add_remaining_players_seconds
        save_stats_to_database
        reset_players
        clear_court
      end
    end

    def reset_minutes
      @player_stats.each {|player, stat| stat[:time] = period_minutes}
    end

    def reset_players
      @player_stats.each {|player, stat| @player_stats[player] = Stat.new.stat_hash}
    end

    def period_minutes
      @quarter <= 4 ? 12*60 : 5*60
    end

    def add_remaining_players_seconds
      @on_court.each do |player|
        player_stat = @player_stats[player]
        player_stat[:sp] += player_stat[:time]
      end
    end

    def save_stats_to_database
      period = Period.find_or_create_by(game: @game, quarter: @quarter)
      @player_stats.each do |player, stat|
        player = @players.find_by_idstr(player)
        player = Player.find_or_create_by(intervalable: period, team: player.team, name: player.name, abbr: player.abbr, idstr: player.idstr)
        stat = stat.dup
        stat.delete(:time)
        player_stat = Stat.find_or_create_by(statable: player)
        player_stat.update(stat)
      end
    end

    def clear_court
      @on_court.clear
    end
  end
end