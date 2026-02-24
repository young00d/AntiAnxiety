import Foundation

struct QuoteRecord: Codable {
    let index: Int
    let dateString: String
}

@Observable
final class DailyQuoteManager {
    private(set) var currentQuote: String = ""
    private var skin: SkinType

    init(skin: SkinType) {
        self.skin = skin
        self.currentQuote = Self.todayQuote(for: skin)
    }

    func updateSkin(_ newSkin: SkinType) {
        skin = newSkin
        currentQuote = Self.todayQuote(for: newSkin)
    }

    // MARK: - Selection Logic

    private static func todayQuote(for skin: SkinType) -> String {
        let quotes = Self.quotes(for: skin)
        let todayKey = dateString(for: Date())
        let userDefaultsKey = "shownQuotes_\(skin.rawValue)"

        // Load history
        var history: [QuoteRecord] = loadHistory(key: userDefaultsKey)

        // Already picked today? Return it
        if let todayRecord = history.first(where: { $0.dateString == todayKey }) {
            let idx = todayRecord.index % quotes.count
            return quotes[idx]
        }

        // Filter out indices shown in last 14 days
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        let cutoffString = dateString(for: cutoffDate)
        let recentIndices = Set(
            history
                .filter { $0.dateString >= cutoffString }
                .map(\.index)
        )

        let availableIndices = (0..<quotes.count).filter { !recentIndices.contains($0) }

        let chosenIndex: Int
        if availableIndices.isEmpty {
            chosenIndex = Int.random(in: 0..<quotes.count)
        } else {
            chosenIndex = availableIndices.randomElement()!
        }

        // Save
        history.append(QuoteRecord(index: chosenIndex, dateString: todayKey))
        // Prune older than 14 days
        history = history.filter { $0.dateString >= cutoffString }
        saveHistory(history, key: userDefaultsKey)

        return quotes[chosenIndex]
    }

    private static func loadHistory(key: String) -> [QuoteRecord] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([QuoteRecord].self, from: data)
        else { return [] }
        return decoded
    }

    private static func saveHistory(_ history: [QuoteRecord], key: String) {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private static func dateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // MARK: - Quote Data

    static func quotes(for skin: SkinType) -> [String] {
        switch skin {
        case .woodenFish: return woodenFishQuotes
        case .threeBody: return threeBodyQuotes
        case .cat: return catQuotes
        }
    }

    // MARK: - 木鱼 · 佛学经文 (50条)

    static let woodenFishQuotes: [String] = [
        "一切有为法，如梦幻泡影，如露亦如电，应作如是观。",
        "色不异空，空不异色，色即是空，空即是色。",
        "应无所住而生其心。",
        "菩提本无树，明镜亦非台，本来无一物，何处惹尘埃。",
        "过去心不可得，现在心不可得，未来心不可得。",
        "凡所有相，皆是虚妄。若见诸相非相，则见如来。",
        "不生不灭，不垢不净，不增不减。",
        "照见五蕴皆空，度一切苦厄。",
        "心无挂碍，无挂碍故，无有恐怖，远离颠倒梦想。",
        "一花一世界，一叶一菩提。",
        "放下屠刀，立地成佛。",
        "诸法因缘生，诸法因缘灭。",
        "千江有水千江月，万里无云万里天。",
        "若能一切随他去，便是世间自在人。",
        "心平何劳持戒，行直何用修禅。",
        "春有百花秋有月，夏有凉风冬有雪。若无闲事挂心头，便是人间好时节。",
        "迷时师度，悟了自度。",
        "不是风动，不是幡动，仁者心动。",
        "万法归一，一归何处。",
        "若以色见我，以音声求我，是人行邪道，不能见如来。",
        "苦海无边，回头是岸。",
        "一念放下，万般自在。",
        "心生种种法生，心灭种种法灭。",
        "人生在世如身处荆棘之中，心不动，人不妄动，不动则不伤。",
        "笑着面对，不去埋怨。悠然，随心，随性，随缘。",
        "一切皆为虚幻。",
        "不悲过去，非贪未来，心系当下，由此安详。",
        "烦恼即菩提，生死即涅槃。",
        "但行好事，莫问前程。",
        "是日已过，命亦随减，如少水鱼，斯有何乐。",
        "一切法得成于忍。",
        "静坐常思己过，闲谈莫论人非。",
        "心如工画师，能画诸世间。五蕴悉从生，无法而不造。",
        "归元性无二，方便有多门。",
        "佛在灵山莫远求，灵山只在汝心头。",
        "何期自性本自清净，何期自性本不生灭。",
        "若真修道人，不见世间过。",
        "前念不生即心，后念不灭即佛。",
        "一切福田，不离方寸。从心而觅，感无不通。",
        "众生皆具如来智慧德相，只因妄想执着不能证得。",
        "无明实性即佛性，幻化空身即法身。",
        "境缘无好丑，好丑起于心。",
        "随缘不是得过且过，而是尽人事听天命。",
        "真正的慈悲在于爱别人，不是爱自己。",
        "学佛是对自己的良心交待，不是做给别人看的。",
        "修行是点滴的功夫，非一蹴而就。",
        "心若无事，万法不生。",
        "行亦禅，坐亦禅，语默动静体安然。",
        "人生如逆旅，我亦是行人。",
        "心安即是归处。",
    ]

    // MARK: - 三体 · 经典语句 (50条)

    static let threeBodyQuotes: [String] = [
        "给岁月以文明，而不是给文明以岁月。",
        "弱小和无知不是生存的障碍，傲慢才是。",
        "失去人性，失去很多；失去兽性，失去一切。",
        "我们都是阴沟里的虫子，但总还是得有人仰望星空。",
        "前进！前进！不择手段地前进！",
        "宇宙很大，生活更大。",
        "死亡是唯一一座永远亮着的灯塔。",
        "碑是那么小，与其说是为了纪念，更像是为了忘却。",
        "你的无畏来源于无知。",
        "生存本来就是一种幸运。",
        "毁灭你，与你有何相干。",
        "藏好自己，做好清理。",
        "黑暗森林中，每个文明都是带枪的猎人。",
        "技术爆炸随时可能到来。",
        "宇宙就是一座黑暗森林。",
        "猜疑链一旦形成，就无法消除。",
        "把字刻在石头上。",
        "我点燃了火，却控制不了它。",
        "大自然真的是自然的吗？",
        "整个宇宙将为你闪烁。",
        "面壁者的真正对手，是他自己。",
        "成为恒星，而非尘埃。",
        "文明像一场五千年的狂奔。",
        "活着本身就很妙，如果连这道理都不懂，怎么去探索更深的东西。",
        "时间是最残忍的武器。",
        "在终极的哲学问题面前，任何智慧都只是孩子的牙牙学语。",
        "仰望星空的人，终将被星空改变。",
        "太阳快要落下去了，你们的孩子居然不害怕。",
        "思想的星光穿越了漫漫黑暗，比所有恒星更加永恒。",
        "逃离是唯一的选择，而文明只能向前。",
        "降维打击，无处可逃。",
        "我有一个梦，也许有一天，灿烂的阳光能照进黑暗森林。",
        "在这寒冷无际的宇宙中，只有程心以自己的方式发出了一点点光和热。",
        "文明不能承受之轻。",
        "理解不是接受的前提。",
        "你们是虫子，但虫子从来就没有被真正战胜过。",
        "在更高的维度上，一切显而易见。",
        "有时候，最大的善意恰恰带来最大的伤害。",
        "人类不感谢罗辑。",
        "三颗无规则运动的恒星，注定了混沌的命运。",
        "宇宙的熵在增加，秩序终将消亡。",
        "给时间以生命，给生命以时间。",
        "面壁者，请面壁。",
        "在宇宙中，你再快都有比你更快的，你再慢也有比你更慢的。",
        "所有的战争都是为了和平。",
        "不要回答！不要回答！不要回答！",
        "我是一个军人，我的职责就是保卫这个世界。",
        "如果我们世界的基础是不真实的，那又如何？",
        "真相往往比想象更加不可思议。",
        "这是人类的落日。",
    ]

    // MARK: - 猫猫 · 生活习性 (50条)

    static let catQuotes: [String] = [
        "猫每天花三分之二的时间在睡觉，一只九岁的猫清醒的时间只有三年。",
        "猫的呼噜声频率在25-150Hz之间，这个频率有助于骨骼愈合和缓解压力。",
        "每只猫的鼻纹都是独一无二的，就像人类的指纹。",
        "猫无法品尝甜味，因为它们缺少感知甜味的基因。",
        "猫的听力比人类灵敏约四倍，能听到超声波。",
        "猫用慢眨眼来表达爱意，这被称为猫之吻。",
        "古埃及人崇拜猫神贝斯特，家中的猫去世后主人会剃掉眉毛来哀悼。",
        "猫可以旋转耳朵180度，每只耳朵有32块肌肉控制。",
        "猫的身体里有230根骨头，比人类多24根。",
        "猫不喜欢水，但土耳其梵猫天生爱游泳。",
        "猫用头蹭你不是因为痒，是在用腺体标记你为它的所有物。",
        "猫的跳跃能力可以达到自身身高的五倍。",
        "世界上第一只进入太空的猫是法国的费利塞特。",
        "猫走路时同侧的前后腿同时迈出，和骆驼、长颈鹿一样。",
        "猫咪露出肚皮不一定是想让你摸，而是表示信任。",
        "猫每天需要约十六小时的睡眠，是哺乳动物中睡眠时间最长的之一。",
        "猫的夜视能力是人类的六倍。",
        "一只猫平均每天梳理自己的毛发约五个小时。",
        "猫的胡须宽度和身体宽度差不多，用来判断能否穿过缝隙。",
        "猫磨爪子不仅是磨指甲，也是在标记领地。",
        "全世界大约有五亿只家猫。",
        "猫能发出超过一百种不同的声音，而狗只有十种左右。",
        "小猫出生时眼睛是闭着的，约七到十天后才会睁开。",
        "猫的大脑结构与人类的相似度高达百分之九十。",
        "猫尾巴直立且微微颤动，代表它见到你非常开心。",
        "猫平均每天喝水量约为体重的百分之三到五。",
        "猫竖起尾巴在你腿边绕来绕去，是在说它想要关注。",
        "猫在追逐猎物时可以达到每小时约五十公里的速度。",
        "猫不能像人一样出汗散热，它们主要通过肉垫来散热。",
        "猫对主人的名字其实有反应，只是选择性忽略。",
        "猫打哈欠不一定是困了，有时是在释放紧张情绪。",
        "大多数橘猫是公猫，比例约为八比二。",
        "猫的短期记忆长度约为十六小时，远超狗的五分钟。",
        "猫喜欢纸箱是因为封闭空间让它们感到安全。",
        "猫的正常体温在三十八到三十九度之间，比人类略高。",
        "猫从高处落下时能自动翻正身体，这叫翻正反射。",
        "猫喜欢待在高处是因为这样更容易观察周围环境。",
        "有些猫对猫薄荷没有反应，这是由基因决定的。",
        "公猫大多是左撇子，母猫大多用右爪。",
        "猫可以感知地震前的微小震动，比人类早很多。",
        "猫对你缓慢眨眼是最大的信任表达，你也可以慢眨回应它。",
        "猫尾巴夹在两腿之间表示紧张或害怕。",
        "猫独自在家时经常会坐在窗边看外面，这被称为猫咪电视。",
        "黑猫在英国和日本被视为幸运的象征。",
        "猫的脚掌肉垫是唯一有汗腺的部位。",
        "猫舔你是一种社交梳理行为，代表它把你当作家人。",
        "小猫会通过揉面团的动作来表达安全感和满足。",
        "猫平均寿命约为十二到十八年，室内猫通常活得更久。",
        "猫在开心时会发出特殊的喉音，那是它在对你表白。",
        "猫的瞳孔可以放大到眼球面积的百分之五十，帮助它们在黑暗中看清一切。",
    ]
}
