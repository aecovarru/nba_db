module Database
  class PlayParser
    STAT_INDICES = [:sp, :fgm, :fga, :thpa, :thpm, :fta, :ftm, :orb, :drb, :ast, :stl, :blk, :tov, :pf, :pts, :time]
    def initialize(options)
      @options = options
      @game = options[:game]
      @stats = options[:stats]
      @on_court = options[:on_court]
      @play = options[:play]
      @player1 = options[:player1]
      @player2 = options[:player2]
      @stat1 = @stats[@player1]
      @stat2 = @stats[@player2]
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
      @stat1[:drb] += 1 if @stat1
    end

    def off_reb
      @stat1[:orb] += 1 if @stat1
    end

    def miss_free
      @stat1[:fta] += 1
    end

    def make_free
      @stat1[:fta] += 1
      @stat1[:ftm] += 1
      @stat1[:pts] += 1
    end

    def miss_two
      @stat1[:fga] += 1
      @stat2[:blk] += 1 if @stat2
    end

    def make_two
      @stat1[:fga] += 1
      @stat1[:fgm] += 1
      @stat1[:pts] += 2
      @stat2[:ast] += 1 if @stat2
    end

    def miss_three
      @stat1[:fga] += 1
      @stat1[:thpa] += 1
      @stat2[:blk] += 1 if @stat2
    end

    def make_three
      @stat1[:fga] += 1
      @stat1[:fgm] += 1
      @stat1[:thpa] += 1 
      @stat1[:thpm] += 1
      @stat1[:pts] += 3
      @stat2[:ast] += 1 if @stat2
    end

    def turnover
      @stat1[:tov] += 1 if @stat1
      @stat2[:stl] += 1 if @stat2
    end

    def substitution
      @on_court.delete(@player2)
      @on_court << @player1
      @stat1[:time] = @time
      if @stat2
        @stat2[:time] = period_minutes if @stat2[:time] == 0
        @stat2[:sp] += @stat2[:time] - @time
        @stat2[:time] = 0
      end
    end

    def double_foul
      @stat1[:pf] += 1
      @stat2[:pf] += 1
    end

    def personal_foul
      @stat1[:pf] += 1 if @stat1
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
      @stats.each {|player, stat| stat[:time] = period_minutes}
    end

    def reset_players
      @stats = Hash[@stats.map do |idstr, stat|
        id = stat[:player_id]
        stat = Stat.new.stat_hash
        stat[:player_id] = id
        stat[:time] = 0
        stat[:starter] = false
        [idstr, stat]
      end]
    end

    def period_minutes
      @quarter <= 4 ? 12*60 : 5*60
    end

    def add_remaining_players_seconds
      @on_court.each do |player|
        player_stat = @stats[player]
        player_stat[:sp] += player_stat[:time]
      end
    end

    def save_stats_to_database
      puts @quarter
      period = Period.find_or_create_by(game: @game, quarter: @quarter)
      @stats.map do |idstr, stat|
        player = Player.find(stat[:player_id])
        stat_hash = stat.reject {|key, value| [:player_id, :time].include?(key)}
        stat_hash.merge!(intervalable: period, statable: player)
        Stat.find_or_create_by(stat_hash)
      end
    end

    def save_stats

    end

    def clear_court
      @on_court.clear
    end
  end
end