require 'nkf'

helpers do
  alias_method :__erb__, :erb 
  alias_method :__haml__, :haml 
end

module Sinatra
  module Emoji
    module Helpers
      def emoji(no)
        "{$#{no}}"
      end

      def erb(template, opts={}, locals={})
        html = __erb__(template, opts, locals)
        html = NKF.nkf('-s -x', html) if options.output_encoding_sjis
        parseEmoji(html)
      end

      def haml(template, opts={}, locals={})
        html = __haml__(template, opts, locals)
        html = NKF.nkf('-s -x', html) if options.output_encoding_sjis
        html = parseEmoji(html)
      end

      def isDocomo
        agent =~ /^DoCoMo/
      end

      def isAU
        agent =~ /^UP.Browser|^KDDI/
      end

      def isSoftbank
        agent =~ /^J-PHONE|^Vodafone|^SoftBank/
      end

      private
      def parseEmoji(html)
        html.gsub(/\{\$(\d+)\}/) do |no|
          encodeEmoji($1.to_i)
        end
      end

      def encodeEmoji(no)
        return '' unless EMOJI_TBL[no]

        carrier = ''
        if isDocomo
          carrier = :i
        elsif isSoftbank
          carrier = :s 
        elsif isAU
          carrier = :e 
        else
          return ''
        end

        code = EMOJI_TBL[no][carrier]
        if code.empty?
          code = EMOJI_TBL[options.default_emoji][carrier]
        end
        [code].pack('H*')
      end

      def agent
        env["HTTP_USER_AGENT"]
      end
    end

    def self.registered(app)
      app.helpers Emoji::Helpers
      app.set :default_emoji, 0 
      app.set :output_encoding_sjis, true
    end
  end

  register Emoji

  EMOJI_TBL = [
    { :i => 'F89F', :e => 'F660', :s => '1B24476A0F' },   # 0:晴れ
    { :i => 'F8A0', :e => 'F665', :s => '1B2447690F' },   # 1:曇り
    { :i => 'F8A1', :e => 'F664', :s => '1B24476B0F' },   # 2:雨
    { :i => 'F8A2', :e => 'F65D', :s => '1B2447680F' },   # 3:雪
    { :i => 'F8A3', :e => 'F65F', :s => '1B24455D0F' },   # 4:雷
    { :i => 'F8A4', :e => 'F641', :s => '1B24476B0F' },   # 5:台風
    { :i => 'F8A5', :e => 'F7B5', :s => '1B2447690F' },   # 6:霧
    { :i => 'F8A6', :e => 'F6BF', :s => '1B24476B0F' },   # 7:小雨
    { :i => 'F8A7', :e => 'F667', :s => '1B24465F0F' },   # 8:牡羊座
    { :i => 'F8A8', :e => 'F668', :s => '1B2446600F' },   # 9:牡牛座
    { :i => 'F8A9', :e => 'F669', :s => '1B2446610F' },   # 10:双子座
    { :i => 'F8AA', :e => 'F66A', :s => '1B2446620F' },   # 11:蟹座
    { :i => 'F8AB', :e => 'F66B', :s => '1B2446630F' },   # 12:獅子座
    { :i => 'F8AC', :e => 'F66C', :s => '1B2446640F' },   # 13:乙女座
    { :i => 'F8AD', :e => 'F66D', :s => '1B2446650F' },   # 14:天秤座
    { :i => 'F8AE', :e => 'F66E', :s => '1B2446660F' },   # 15:蠍座
    { :i => 'F8AF', :e => 'F66F', :s => '1B2446670F' },   # 16:射手座
    { :i => 'F8B0', :e => 'F670', :s => '1B2446680F' },   # 17:山羊座
    { :i => 'F8B1', :e => 'F671', :s => '1B2446690F' },   # 18:水瓶座
    { :i => 'F8B2', :e => 'F672', :s => '1B24466A0F' },   # 19:魚座
    { :i => 'F8B3', :e => 'F643', :s => '1B2447260F' },   # 20:スポーツ
    { :i => 'F8B4', :e => 'F693', :s => '1B2447360F' },   # 21:野球
    { :i => 'F8B5', :e => 'F7B6', :s => '1B2447340F' },   # 22:ゴルフ
    { :i => 'F8B6', :e => 'F690', :s => '1B2447350F' },   # 23:テニス
    { :i => 'F8B7', :e => 'F68F', :s => '1B2447380F' },   # 24:サッカー
    { :i => 'F8B8', :e => 'F691', :s => '1B2447330F' },   # 25:スキー
    { :i => 'F8B9', :e => 'F7B7', :s => '1B2445510F' },   # 26:バスケットボール
    { :i => 'F8BA', :e => 'F692', :s => '1B2445520F' },   # 27:モータースポーツ
    { :i => 'F8BB', :e => 'F7B8', :s => '1B24456E0F' },   # 28:ポケットベル
    { :i => 'F8BC', :e => 'F68E', :s => '1B24473E0F' },   # 29:電車
    { :i => 'F8BD', :e => 'F68E', :s => '1B2450540F' },   # 30:地下鉄
    { :i => 'F8BE', :e => 'F689', :s => '1B24473F0F' },   # 31:新幹線
    { :i => 'F8BF', :e => 'F68A', :s => '1B24473B0F' },   # 32:車（セダン）
    { :i => 'F8C0', :e => 'F68A', :s => '1B24473B0F' },   # 33:車（RV）
    { :i => 'F8C1', :e => 'F688', :s => '1B2445790F' },   # 34:バス
    { :i => 'F8C2', :e => 'F68D', :s => '1B2446220F' },   # 35:船
    { :i => 'F8C3', :e => 'F68C', :s => '1B24473D0F' },   # 36:飛行機
    { :i => 'F8C4', :e => 'F684', :s => '1B2447560F' },   # 37:家
    { :i => 'F8C5', :e => 'F686', :s => '1B2447580F' },   # 38:ビル
    { :i => 'F8C6', :e => 'F6F4', :s => '1B2445730F' },   # 39:郵便局
    { :i => 'F8C7', :e => 'F758', :s => '1B2445750F' },   # 40:病院
    { :i => 'F8C8', :e => 'F683', :s => '1B24456D0F' },   # 41:銀行
    { :i => 'F8C9', :e => 'F67B', :s => '1B2445740F' },   # 42:ATM
    { :i => 'F8CA', :e => 'F686', :s => '1B2445780F' },   # 43:ホテル
    { :i => 'F8CB', :e => 'F67C', :s => '1B2445760F' },   # 44:コンビニ
    { :i => 'F8CC', :e => 'F78E', :s => '1B24475A0F' },   # 45:ガソリンスタンド
    { :i => 'F8CD', :e => 'F67E', :s => '1B24456F0F' },   # 46:駐車場
    { :i => 'F8CE', :e => 'F642', :s => '1B24456E0F' },   # 47:信号
    { :i => 'F8CF', :e => 'F67D', :s => '1B2445590F' },   # 48:トイレ
    { :i => 'F8D0', :e => 'F685', :s => '1B2447630F' },   # 49:レストラン
    { :i => 'F8D1', :e => 'F7B4', :s => '1B2447650F' },   # 50:喫茶店
    { :i => 'F8D2', :e => 'F69B', :s => '1B2447640F' },   # 51:バー
    { :i => 'F8D3', :e => 'F69C', :s => '1B2447670F' },   # 52:ビール
    { :i => 'F8D4', :e => 'F6AF', :s => '1B2445400F' },   # 53:ファーストフード
    { :i => 'F8D5', :e => 'F6E6', :s => '1B24455E0F' },   # 54:ブティック
    { :i => 'F8D6', :e => 'F6EF', :s => '1B24454E0F' },   # 55:美容院
    { :i => 'F8D7', :e => 'F6DC', :s => '1B24475C0F' },   # 56:カラオケ
    { :i => 'F8D8', :e => 'F6F0', :s => '1B24475D0F' },   # 57:映画
    { :i => 'F8D9', :e => 'F771', :s => '1B2446560F' },   # 58:右斜め上
    { :i => 'F8DA', :e => 'F645', :s => '1B2445440F' },   # 59:遊園地
    { :i => 'F8DB', :e => 'F6DE', :s => '1B24475E0F' },   # 60:音楽
    { :i => 'F8DC', :e => 'F7B9', :s => '1B2446250F' },   # 61:アート
    { :i => 'F8DD', :e => 'F66C', :s => '1B2447240F' },   # 62:演劇
    { :i => 'F8DE', :e => 'F7BB', :s => '1B2447570F' },   # 63:イベント
    { :i => 'F8DF', :e => 'F676', :s => '1B2445450F' },   # 64:チケット
    { :i => 'F8E0', :e => 'F655', :s => '1B24453D0F' },   # 65:喫煙
    { :i => 'F8E1', :e => 'F656', :s => '1B2446280F' },   # 66:禁煙
    { :i => 'F8E2', :e => 'F6EE', :s => '1B2447280F' },   # 67:カメラ
    { :i => 'F8E3', :e => 'F674', :s => '1B24453E0F' },   # 68:カバン
    { :i => 'F8E4', :e => 'F782', :s => '1B2445680F' },   # 69:本
    { :i => 'F8E5', :e => 'F7BC', :s => '1B2445300F' },   # 70:リボン
    { :i => 'F8E6', :e => 'F6A8', :s => '1B2445320F' },   # 71:プレゼント
    { :i => 'F8E7', :e => 'F7BD', :s => '1B2447660F' },   # 72:バースデー
    { :i => 'F8E8', :e => 'F7B3', :s => '1B2447290F' },   # 73:電話
    { :i => 'F8E9', :e => 'F7A5', :s => '1B24472A0F' },   # 74:携帯電話
    { :i => 'F8EA', :e => 'F78B', :s => '1B2445680F' },   # 75:メモ
    { :i => 'F8EB', :e => 'F6DB', :s => '1B24454A0F' },   # 76:TV
    { :i => 'F8EC', :e => 'F69F', :s => '1B24454B0F' },   # 77:ゲーム
    { :i => 'F8ED', :e => 'F6E5', :s => '1B2445460F' },   # 78:CD
    { :i => 'F8EE', :e => 'F7B2', :s => '1B24462C0F' },   # 79:ハート
    { :i => 'F8EF', :e => 'F7BE', :s => '1B24462E0F' },   # 80:スペード
    { :i => 'F8F0', :e => 'F7BF', :s => '1B24462D0F' },   # 81:ダイヤ
    { :i => 'F8F1', :e => 'F7C0', :s => '1B24462F0F' },   # 82:クラブ
    { :i => 'F8F2', :e => 'F7C1', :s => '1B2445250F' },   # 83:目
    { :i => 'F8F3', :e => 'F7C2', :s => '1B2445610F' },   # 84:耳
    { :i => 'F8F4', :e => 'F6CC', :s => '1B24472D0F' },   # 85:グー
    { :i => 'F8F5', :e => 'F7C3', :s => '1B2447310F' },   # 86:チョキ
    { :i => 'F8F6', :e => 'F7C4', :s => '1B2447320F' },   # 87:パー
    { :i => 'F8F7', :e => 'F769', :s => '1B2446580F' },   # 88:右斜め下
    { :i => 'F8F8', :e => 'F768', :s => '1B2446570F' },   # 89:左斜め上
    { :i => 'F8F9', :e => 'F6C7', :s => '1B2446210F' },   # 90:足
    { :i => 'F8FA', :e => 'F6F3', :s => '1B2447270F' },   # 91:くつ
    { :i => 'F8FB', :e => 'F6D7', :s => '1B2446310F' },   # 92:眼鏡
    { :i => 'F8FC', :e => 'F657', :s => '1B24462A0F' },   # 93:車椅子
    { :i => 'F940', :e => 'F7C5', :s => ''           },   # 94:新月
    { :i => 'F941', :e => 'F7C6', :s => '1B24476C0F' },   # 95:やや欠け月
    { :i => 'F942', :e => 'F7C7', :s => '1B24476C0F' },   # 96:半月
    { :i => 'F943', :e => 'F65E', :s => '1B24476C0F' },   # 97:三日月
    { :i => 'F944', :e => 'F661', :s => ''           },   # 98:満月
    { :i => 'F945', :e => 'F6BA', :s => '1B2447730F' },   # 99:犬
    { :i => 'F946', :e => 'F6B4', :s => '1B2447700F' },   # 100:猫
    { :i => 'F947', :e => 'F6BB', :s => '1B24473C0F' },   # 101:リゾート
    { :i => 'F948', :e => 'F6A2', :s => '1B2447530F' },   # 102:クリスマス
    { :i => 'F949', :e => 'F772', :s => '1B2446590F' },   # 103:左斜め下
    { :i => 'F972', :e => 'F6F7', :s => '1B2445240F' },   # 104:phoneto
    { :i => 'F973', :e => 'F6FA', :s => '1B2445230F' },   # 105:mailto
    { :i => 'F974', :e => 'F6F9', :s => '1B24472B0F' },   # 106:faxto
    { :i => 'F975', :e => 'F65A', :s => ''           },   # 107:iモード
    { :i => 'F976', :e => 'F65A', :s => ''           },   # 108:iモード
    { :i => 'F977', :e => 'F7AE', :s => '1B2445230F' },   # 109:メール
    { :i => 'F978', :e => 'F6B0', :s => ''           },   # 110:ドコモ提供
    { :i => 'F979', :e => 'F6B1', :s => ''           },   # 111:ドコモポイント
    { :i => 'F97A', :e => 'F79A', :s => '1B2446350F' },   # 112:有料
    { :i => 'F97B', :e => 'F795', :s => '1B2446360F' },   # 113:無料
    { :i => 'F97C', :e => 'F6C3', :s => '1B2446490F' },   # 114:ID
    { :i => 'F97D', :e => 'F6F2', :s => '1B24475F0F' },   # 115:パスワード
    { :i => 'F97E', :e => 'F779', :s => '1B2446500F' },   # 116:次頁有
    { :i => 'F980', :e => 'F7C8', :s => ''           },   # 117:クリア
    { :i => 'F981', :e => 'F6F1', :s => '1B2445340F' },   # 118:サーチ
    { :i => 'F982', :e => 'F7E5', :s => '1B2446320F' },   # 119:NEW
    { :i => 'F983', :e => 'F78F', :s => '1B24456B0F' },   # 120:位置情報
    { :i => 'F984', :e => 'F795', :s => '1B2446310F' },   # 121:フリーダイヤル
    { :i => 'F985', :e => 'F7B3', :s => '1B2446300F' },   # 122:シャープダイヤル
    { :i => 'F986', :e => 'F748', :s => ''           },   # 123:モバQ
    { :i => 'F987', :e => 'F6FB', :s => '1B24463C0F' },   # 124:1
    { :i => 'F988', :e => 'F6FC', :s => '1B24463D0F' },   # 125:2
    { :i => 'F989', :e => 'F740', :s => '1B24463E0F' },   # 126:3
    { :i => 'F98A', :e => 'F741', :s => '1B24463F0F' },   # 127:4
    { :i => 'F98B', :e => 'F742', :s => '1B2446400F' },   # 128:5
    { :i => 'F98C', :e => 'F743', :s => '1B2446410F' },   # 129:6
    { :i => 'F98D', :e => 'F744', :s => '1B2446420F' },   # 130:7
    { :i => 'F98E', :e => 'F745', :s => '1B2446430F' },   # 131:8
    { :i => 'F98F', :e => 'F746', :s => '1B2446440F' },   # 132:9
    { :i => 'F990', :e => 'F7C9', :s => '1B2446450F' },   # 133:0
    { :i => 'F9B0', :e => 'F7CA', :s => '1B24466D0F' },   # 135:決定
    { :i => 'F991', :e => 'F6C3', :s => '1B2447420F' },   # 135:黒ハート
    { :i => 'F992', :e => 'F7CC', :s => '1B2447420F' },   # 136:揺れるハート
    { :i => 'F993', :e => 'F64F', :s => '1B2447430F' },   # 137:失恋
    { :i => 'F994', :e => 'F650', :s => '1B2447420F' },   # 138:ハート達
    { :i => 'F995', :e => 'F649', :s => '1B2447770F' },   # 139:わーい
    { :i => 'F996', :e => 'F64A', :s => '1B2447790F' },   # 140:ちっ
    { :i => 'F997', :e => 'F64B', :s => '1B2447780F' },   # 141:がく〜
    { :i => 'F998', :e => 'F64C', :s => '1B2445270F' },   # 142:もうやだ〜
    { :i => 'F999', :e => 'F7CB', :s => '1B2445270F' },   # 143:ふらふら
    { :i => 'F99A', :e => 'F3EE', :s => '1B2446560F' },   # 144:グッド
    { :i => 'F99B', :e => 'F7EE', :s => '1B24475E0F' },   # 145:るんるん
    { :i => 'F99C', :e => 'F695', :s => '1B2445430F' },   # 146:いい気分（温泉）
    { :i => 'F99D', :e => 'F6B0', :s => '1B2446240F' },   # 147:かわいい
    { :i => 'F99E', :e => 'F6C4', :s => '1B2447230F' },   # 148:キスマーク
    { :i => 'F99F', :e => 'F37E', :s => '1B244F4E0F' },   # 149:ぴかぴか（新しい）
    { :i => 'F9A0', :e => 'F64E', :s => '1B24452F0F' },   # 150:ひらめき
    { :i => 'F9A1', :e => 'F64A', :s => '1B2446260F' },   # 151:むかっ（怒り）
    { :i => 'F9A2', :e => 'F6CC', :s => '1B24472D0F' },   # 152:パンチ
    { :i => 'F9A3', :e => 'F652', :s => '1B24453C0F' },   # 153:爆弾
    { :i => 'F9A4', :e => 'F65E', :s => '1B24475E0F' },   # 154:ムード
    { :i => 'F9A5', :e => 'F75C', :s => '1B2446580F' },   # 155:バッド
    { :i => 'F9A6', :e => 'F64D', :s => '1B24455C0F' },   # 156:眠い（睡眠）
    { :i => 'F9A7', :e => 'F65A', :s => '1B2447410F' },   # 157:exclamation
    { :i => 'F9A8', :e => 'F65B', :s => '1B2447400F' },   # 158:exclamation&question
    { :i => 'F9A9', :e => 'F3F1', :s => '1B2447410F' },   # 159:exclamation×2
    { :i => 'F9AA', :e => 'F7CD', :s => '1B2446260F' },   # 160:どんっ（衝撃）
    { :i => 'F9AB', :e => 'F7CE', :s => '1B2446390F' },   # 161:あせあせ（飛び散る汗）
    { :i => 'F9AC', :e => 'F6BF', :s => '1B2445280F' },   # 162:たらーっ（汗）
    { :i => 'F9AD', :e => 'F6CD', :s => '1B2445350F' },   # 163:ダッシュ（走り出す様）
    { :i => 'F9AE', :e => 'F74D', :s => ''           },   # 164:ー（長音記号1）
    { :i => 'F9AF', :e => 'F74E', :s => ''           },   # 165:ー（長音記号2）
    { :i => 'F950', :e => 'F697', :s => '1B2445330F' },   # 166:カチンコ
    { :i => 'F951', :e => 'F6A0', :s => '1B24454F0F' },   # 167:袋
    { :i => 'F952', :e => 'F679', :s => '1B2445680F' },   # 168:ペン
    { :i => 'F955', :e => 'F6D4', :s => '1B2447210F' },   # 169:人影
    { :i => 'F956', :e => 'F657', :s => '1B24453F0F' },   # 170:椅子
    { :i => 'F957', :e => 'F640', :s => '1B2445660F' },   # 171:夜
    { :i => 'F95B', :e => 'F778', :s => '1B2446510F' },   # 172:soon
    { :i => 'F95C', :e => 'F6E8', :s => '1B24465A0F' },   # 173:on
    { :i => 'F95D', :e => 'F779', :s => '1B2446500F' },   # 174:end
    { :i => 'F95E', :e => 'F7B1', :s => '1B24474D0F' }    # 175:時計
  ]
end
