# Story Writing Skills 设计草案 v0.1

> 目标：打造一套小说写作 skills，在小说创作领域达到 mattpocock/skills 在工程领域的地位。
> 定位：通用（超长篇连载 / 常规长篇 / 中短篇都覆盖，靠 `/setup-story` 时的配置区分）。
> 语言：skill 全部用中文写，术语表用中文定义。
> 依据：见《matt-skills-精读笔记.md》。

## 一、核心洞察：工程和小说共享同一个根问题

长篇小说和大型代码库的困难同构：**规模超出单个上下文窗口，一致性必须跨会话维持**。
所以 Matt 的架构几乎可以逐项翻译，但小说有三个工程没有的独有难题，
它们是这套体系最有价值的差异化部分：

1. **伏笔账本**——埋下的每条伏笔都是一个"未 resolve 的 promise"，必须被回收或显式废弃。
2. **信息差追踪**——哪个角色在哪一章知道了什么。这是连贯性 bug 的最大来源（角色说出了他不该知道的事）。
3. **文风即规范**——工程有 lint 和测试，小说的"规范"是文风契约：几段作者认可的范文 + 正向表述的风格规则。

## 二、三支柱的翻译

| Matt 支柱 | 小说版 |
|---|---|
| 动工前对齐（grilling） | 动笔前把前提、主题、人物动机盘问清楚，沉淀进故事圣经 |
| 共享领域语言（CONTEXT.md） | 术语表：场景/节拍/弧线/伏笔/信息差/修订轴……全体系说同一种话 |
| 持续反馈回路（tdd / code-review） | 场景验收单（写前立判据，写后核对）+ 分轴修订 |

## 三、状态外置：一部作品的目录结构（由 /setup-story 生成）

```
<作品名>/
├── bible/                  # 故事圣经（单一事实源）
│   ├── premise.md          # 前提、主题、类型承诺
│   ├── characters/         # 每角色一文件：欲望、恐惧、弧线、语言习惯
│   ├── world.md            # 世界观规则（含"硬规则"：违反即 bug）
│   └── timeline.md         # 大事年表
├── outline/
│   ├── arcs.md             # 卷/弧规划（多卷作品）
│   └── beats.md            # 当前弧的节拍表
├── scene-cards/            # 场景卡 = 工单（一卡一文件，编号+阻塞边）
├── manuscript/             # 正文（一章一文件）
├── ledger/                 # 账本（每章写完必须更新）
│   ├── foreshadowing.md    # 伏笔账本：埋设处/预定回收处/状态
│   ├── knowledge.md        # 信息差矩阵：谁在哪章知道了什么
│   └── threads.md          # 情节线状态：每条线上次出现在哪、悬在哪
├── style/
│   ├── voice.md            # 文风契约：正向规则 + 避免清单
│   └── samples/            # 作者认可的范文段落（文风的事实源）
└── CONTEXT.md              # 本作品术语表（人名地名功法官职等专名 + 叙事术语）
```

原则：**上下文窗口是易失的，文件是持久的。** 任何 skill 不得依赖对话记忆中
才有的设定——不在圣经/账本里的设定视为不存在。

## 四、Skill 清单

### 用户触发型（流程编排，互不调用）

| skill | 对标 | 治什么失败模式 |
|---|---|---|
| `/setup-story` | setup-matt-pocock-skills | 每部作品结构不一致，skill 找不到状态。生成上述目录，访谈式配置：形态（连载/长篇/短篇）、视角策略、更新节奏 |
| `/ask-editor` | ask-matt | 记不住有哪些 skill。router：定义主流程与各 skill 使用时机 |
| `/grill-premise` | grill-with-docs | 前提没想清楚就开写。frontier 式轮询盘问，沉淀进 bible/ |
| `/brainstorm` | writing-fragments | 灵感被过早结构化杀死。explore 分相：无结构挖掘碎片进素材堆 |
| `/to-outline` | to-spec | 对话里聊嗨了但没固化。exploit 分相：素材+对话 → 节拍表，不重新访谈、只综合 |
| `/to-scenes` | to-tickets | 大纲到正文跨度太大。节拍表 → 场景卡，每卡含 POV/目标/冲突/转折/出场信息差/尺寸约束（一卡=一个新鲜窗口写得完）+ 阻塞边 |
| `/draft-scene` | implement | 无判据地写、写完不核对。取一张场景卡：立验收单 → 写正文（调用文风/一致性纪律）→ 对单核对 → 更新账本 |
| `/revise` | code-review | 修订时什么都想改，结果什么都改不好。分轴修订，一次一轴，轴间不合并（见下） |
| `/chapter-handoff` | handoff | 跨会话失忆。把本次会话压缩成交接文档：情节推进到哪、账本变更、下章意图 |
| `/series-map` | wayfinder | 多卷大坑迷雾。决策地图：产出决策而非章节 |

### 模型触发型（纪律与词汇，description 写清触发分支）

| skill | 对标 | 内容 |
|---|---|---|
| `canon-check` | resolving-merge-conflicts | 新写内容与圣经冲突时的裁决程序：溯源双方意图，改稿或改圣经，禁止静默两存 |
| `scene-craft` | codebase-design | 场景写作词汇层：场景=目标→冲突→转折→钩子；进晚出早；每场必须改变某个值 |
| `style-guard` | tdd 的 tests.md | 文风纪律：写作时对照 style/voice.md 与范文；规则全部正向表述 |
| `plot-doctor` | diagnosing-bugs | 情节问题诊断循环：先构造"能稳定复现问题的最小复述"，再假设→验证→修，禁止无复现就动稿 |
| `grilling`（复用原语） | grilling | 访谈原语：frontier、轮、事实归 agent 查、决策归用户定 |
| `ledger-discipline` | domain-modeling | 账本纪律：什么算伏笔、何时记账、状态机（埋设→强化→回收/废弃）；被 draft-scene 和 revise 调用 |

### /revise 的修订轴（并行子代理，报告并列不合并）

1. **连贯性轴**：对照圣经+账本查设定/时间线/信息差违例——只查事实，不评文笔。
2. **节奏轴**：场景推进是否拖沓、钩子是否成立——只看结构。
3. **文笔轴**：对照文风契约逐段——只改表达，不动情节。

## 五、主流程（/ask-editor 的骨干）

```
新作品：/setup-story → /grill-premise（圣经成形）
      → [大坑？→ /series-map 先清雾]
      → /brainstorm（可选，探索分相）→ /to-outline → /to-scenes
日常写作循环（每章）：
      新会话 → 读交接文档 → /draft-scene（一或多卡）
      → 更新账本 → /chapter-handoff → 清空上下文
修订：/revise（指定范围+轴）
卡壳：plot-doctor；设定打架：canon-check
```

上下文卫生：对齐→大纲→拆卡保持一个不间断窗口；每章写作从新窗口开始，
靠交接文档+账本恢复状态，而非靠长对话。

## 六、MVP 与迭代路线

**不要一次写完 16 个 skill。** Matt 的仓库是失败模式驱动迭代出来的（in-progress/
和 deprecated/ 目录就是证据）。

- **M1（骨架）**：CONTEXT.md 术语表 + `/setup-story` + `/grill-premise`
- **M2（最小流水线）**：`/to-outline` + `/to-scenes` + `/draft-scene`（内联简版文风与账本纪律，先不拆独立 skill）
- **M3（实战检验）**：真的写 2–3 章，记录每个失灵点（OOC？忘伏笔？文风漂移？节奏拖？）
- **M4（失败模式驱动增补）**：每个实测失灵点固化成一个纪律 skill；此时才拆出 `style-guard`、`ledger-discipline`、`/revise`
- 仓库同样设 `in-progress/` 与 `deprecated/`，同样为自己维护 CONTEXT.md（吃自己的狗粮）

## 七、写 skill 时必须遵守的元规则（来自 writing-for-agents）

1. 每个 skill 开头一句话说清"这是什么、不是什么"，结尾有"超出范围"。
2. 步骤以可检查、穷尽式的完成判据结尾（"账本中每条状态为『待回收』的伏笔均已核对"）。
3. 模板用标签内联在 SKILL.md 里；长参考外置成同目录文件，用指针按需加载。
4. 为核心纪律选定锚点词并全体系复用：**圣经、账本、场景卡、信息差、轴、接地、交接**。
5. 文风规则正向表述（写"用具体的动词"，不写"不要用副词堆砌"）。
6. 定期剪枝：逐句问"删掉这句，行为会变吗？"——不变就删。
