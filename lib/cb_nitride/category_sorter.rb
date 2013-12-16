module CbNitride
  class CategorySorter

    ISSUE_CODE = "1"
    COLLECTION_CODE = "3"
    MERCHANDISE_CODES = ["2", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]

    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def sort
      return hash[:category_code] unless hash[:category_code].nil?
      return ISSUE_CODE if is_variant?
      return COLLECTION_CODE if is_collection?
      return "16" if is_merch?
      return ISSUE_CODE if is_issue?
    end

    def is_variant?
      return @is_variant unless @is_variant.nil?
      @is_variant = true if hash[:title].include? "VAR ED"
      @is_variant = true if hash[:title].include? "COMBO PACK"
      @is_variant = true if hash[:title].include? "STANDARD ED"
      @is_variant = true if hash[:title].match(/(CVR)\s[B-Z]/)
      @is_variant = false if @is_variant.nil?
      @is_variant = false if specific_issue_patterns(hash[:title])
      return @is_variant
    end

    def is_issue?
      return @is_issue unless @is_issue.nil?
      if specific_issue_patterns(hash[:title])
        @is_issue = true
      elsif is_variant?
        @is_issue = false
      elsif is_collection?
        @is_issue = false
      elsif is_merch?
        @is_issue = false
      else
        @is_issue = true
      end
      return @is_issue
    end

    def is_collection?
      return @is_collection unless @is_collection.nil?
      @is_collection = true if hash[:title].include?(" GN ")
      @is_collection = true if hash[:title].include?(" TP ")
      @is_collection = true if hash[:title].match(/\s(VOL)\s\d+/)
      @is_collection = false if hash[:title].match(/\s[#]\d+/)
      @is_collection = false if @is_collection.nil?
      return @is_collection
    end

    def is_merch?
      return @is_merch unless @is_merch.nil?
      case hash[:creators]
      when ""
        @is_merch = true
      else
        @is_merch = false
      end
      return @is_merch
    end

    private

    def strict_issue_title_matcher(title)
      /^(#{title})\s[#]/
    end

    def specific_issue_patterns(title)
      title.match(/(CVR)\s[A]/) ||
        title.match(strict_issue_title_matcher("RED SONJA")) ||
        title.match(strict_issue_title_matcher("VAMPIRELLA")) ||
        title.match(strict_issue_title_matcher("ARMY OF DARKNESS VS HACK SLASH")) ||
        title.match(/\d\D+(PTG)$/)
        title.match(/(REORDER ED)$/)
        title.include?("VAR INCENTIVE CVR") ||
        title.include?("DIRECT MARKET CVR") ||
        title.include?("MAIN CVRS")
    end
  end
end
