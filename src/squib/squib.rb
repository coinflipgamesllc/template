require 'mechanize'
require 'combine_pdf'
require 'squib'

module Squib
    def gsheet(sheet_id, index=0)
        agent = Mechanize.new
        response = agent.get_file("https://docs.google.com/spreadsheets/d/e/#{sheet_id}/pub?gid=#{index}&output=csv")
        response = response.encode("ascii-8bit").force_encoding("utf-8")

        return Squib.csv data: response
    end
    module_function :gsheet

    def combine_pdfs(sheets, name)
        pdf = CombinePDF.new

        sheets.each do |sheet|
            front = CombinePDF.load(sheet[:front])

            # Collate the back pages immediately after the relevant page,
            # if a back-side is provided.
            if sheet.key?(:back) then
                back = CombinePDF.load(sheet[:back])
            end

            i = 0
            front.pages.each do |page|
                pdf << page
                if sheet.key?(:back) then
                    pdf << back.pages[i]
                end

                if i == front.pages.count - 1 then
                    break
                end

                i += 1
            end
        end

        pdf.save "docs/pnp/#{name}.pdf"
    end
    module_function :combine_pdfs

    class Deck
        def pnp(opts = {})
            cut_zone stroke_color: '#888'
            defaults = { trim: 37.5, sprue: opts[:rtl] ? 'src/layout/poker-back.yml' : 'src/layout/poker.yml', dir: 'docs/pnp' }
            save_pdf(opts.merge defaults)
        end

        def tgc(opts = {})
            defaults = { dir: 'docs/tgc' }
            save_png(opts.merge defaults)
        end

        def tts(opts = {})
            defaults = { columns: 10, rows: 7, trim: 37.5, dir: 'docs/tts' }
            save_sheet(opts.merge defaults)
        end
    end

    def subset(column, criteria, matching = true)
        sub = {}; column.each_with_index{ |c, i| (sub[criteria.(c)] ||= []) << i }

        return sub[matching]
    end
    module_function :subset
end
