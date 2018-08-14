class Captcha
    def self.generate(text=nil, numeric=false)
        # Original ImageMagick command
        # convert -size 290x70 xc:white -bordercolor black -border 5 \
        # -fill black -stroke black -strokewidth 1 -font TimesNewRoman -pointsize 40 \
        # -draw "translate ${xx1},${yy1} skewX $ss1 gravity center text 0,0 '$cc1'" \
        # -draw "translate ${xx2},${yy2} skewX $ss2 gravity center text 0,0 '$cc2'" \
        # -draw "translate ${xx3},${yy3} skewX $ss3 gravity center text 0,0 '$cc3'" \
        # -draw "translate ${xx4},${yy4} skewX $ss4 gravity center text 0,0 '$cc4'" \
        # -draw "translate ${xx5},${yy5} skewX $ss5 gravity center text 0,0 '$cc5'" \
        # -draw "translate ${xx6},${yy6} skewX $ss6 gravity center text 0,0 '$cc6'" \
        # -fill none -strokewidth 2 \
        # -draw "bezier ${bx1},${by1} ${bx2},${by2} ${bx3},${by3} ${bx4},${by4}" \
        # -draw "polyline ${bx4},${by4} ${bx5},${by5} ${bx6},${by6}" \
        # $outfile

        # MiniMagick Practice
        if numeric
            ambiguous_chars = []
            o = [('0'..'9')].map(&:to_a).flatten - ambiguous_chars
        else
            ambiguous_chars = ["0", "O", "1", "I", "L"]
            o = [('0'..'9'), ('A'..'Z')].map(&:to_a).flatten - ambiguous_chars
        end
        text ||= (0...6).map { o[rand(o.length)] }.join
        tempfile = Tempfile.new(["captcha", ".jpg"])
        colors = ["#3d46c9", "#e87200", "#096c48", "#d5b132", "#0a1d00"]
        image = MiniMagick::Tool::Convert.new do |b|
            # Image resolution
            b.size "300x70"
            # Background color
            b.xc "white"
            # Text or Lines stroke width
            b.strokewidth "3"
            # Font
            b.font "#{Rails.root}/requirement/UbuntuMono-R.ttf"
            # Font size
            b.pointsize "40"
            text.split("").each_with_index do |character, i|
                color = colors.sample
                b.fill color
                b.stroke color
                # Put a character
                b.draw "translate #{(280 / text.length) * i + rand(5..5) + 20},#{rand(50..50)} skewX #{rand(-50..50)} text 0,0 '#{character}'"
            end
            b.fill "none"
            b.strokewidth "2"
            # put Lines
            4.times do
                color = colors.sample
                b.fill color
                b.stroke color
                b.draw "polyline
                #{rand(0..50)},#{rand(0..70)}
                #{rand(250..300)},#{rand(0..70)}"
            end
            # Add border
            b.bordercolor "black"
            b.border "5"

            b << tempfile.path
        end
        # puts "Tempfile path: #{tempfile.path}"
        base64_encoded_image = Base64.encode64(open(tempfile.path).to_a.join).gsub("\n", "")
        tempfile.rewind
        tempfile.close
        tempfile.unlink
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
        answer = {:original_answer => text, :expired_at => Time.now + 5.minute}.to_json
        return {
            :base64_encoded_image => base64_encoded_image,
            :answer => crypt.encrypt_and_sign(answer)
        }
    end
end
