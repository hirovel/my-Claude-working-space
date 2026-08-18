# mattpocock/skills 精读笔记

> 精读对象：https://github.com/mattpocock/skills （全量克隆后逐文件阅读）
> 目的：提炼其架构原则与写法，作为构建自己的 story-writing skills 体系的地基。

## 一、仓库宏观架构

```
skills/
├── engineering/     # 主力：日常代码工作流
├── productivity/    # 通用：访谈、交接、教学、写作元技能
├── misc/            # 杂项：git 护栏、pre-commit 等
├── in-progress/     # 孵化区：未成熟的 skill（含三个写作 skill）
└── deprecated/      # 墓地：淘汰的 skill 不删除，留档
docs/                # 面向人类的每-skill 文档（与 SKILL.md 分离）
CONTEXT.md           # 仓库自身的领域术语表
```

关键观察：

1. **每个 skill 一个目录**：`SKILL.md` 是主文件，附属参考文件放同目录（如 `tdd/tests.md`、`tdd/mocking.md`、`domain-modeling/CONTEXT-FORMAT.md`），按需通过指针加载（progressive disclosure）。
2. **有生命周期管理**：`in-progress` 孵化、`deprecated` 留档。skill 不是一次写成的，是迭代出来的。
3. **仓库自己吃自己的狗粮**：根目录 `CONTEXT.md` 用 domain-modeling 的格式定义了 Issue / Issue tracker / Triage role 等术语，并标注 `_Avoid_`（避免使用的同义词）。

## 二、双轨调用模型（整个体系的骨架）

所有 skill 分两类，靠 frontmatter 里的 `disable-model-invocation: true` 区分：

| | 用户触发型 | 模型触发型 |
|---|---|---|
| 谁能调用 | 只有人（`/name`） | 模型自主 + 人 + 其他 skill |
| description 的角色 | 给人看的一行摘要 | **永久加载的 context pointer**，必须写清触发分支 |
| 成本 | 认知负载（人要记得它存在） | 上下文负载（每回合都占 token 和注意力） |
| 典型 | `/to-spec` `/implement` `/handoff` | `tdd` `diagnosing-bugs` `grilling` |

硬规则：
- **用户触发型之间永不互相调用**（它们没有 description，谁也够不到谁）。两个用户触发型共享的参考材料放到 skill 系统之外的普通文件里。
- 只有当"模型必须能自己够到它"或"别的 skill 要调用它"时才选模型触发；否则一律用户触发，省下上下文负载。
- 用户触发型多到记不住时，用 **router skill**（`ask-matt`）解决：一个 skill 罗列所有 skill 及使用时机，人只需记住一个入口。router 只能"指路"，不能替你触发。

## 三、writing-for-agents：写 skill 的元原则

这是整个仓库信息密度最高的文件，原则如下：

1. **Context pointer**：skill 的 description、AGENTS.md 里指向文档的一行，都是"指针"——指针的**措辞**（不是目标内容）决定模型何时、多可靠地够到那份材料。重要材料 + 弱指针 = 方差 bug，先改措辞，改不好才内联。
2. **两种负载**：每份文档/指针都在花两种预算之一——上下文负载（常驻窗口）或认知负载（人脑索引）。认知负载不是要归零的成本，它是人类主导权的价格。
3. **信息层级三档**：① 文件内步骤（首要）；② 文件内参考（按需查阅）；③ 外置参考（指针触发才加载）。**分支是最干净的外置判据**：所有分支都需要的内联，只有部分分支到达的外置。
4. **Co-location**：一个概念的定义、规则、注意事项放在同一标题下，别散落。检验标准："这份文档读起来像为 agent 写的文档吗？"
5. **完成判据（completion criterion）**：每个步骤以一个判据结尾，两个属性是杠杆——**清晰度**（能否分辨做完/没做完；模糊判据引发"提前收工"）和**要求度**（"每个修改过的模型都已核对"迫使深挖，"产出一份变更清单"不会）。最强的判据既可检查又要求穷尽。
6. **Leading words**：用预训练里已存在的紧凑概念做锚点（tracer bullets、red、tight、fog of war）。一个词反复作为 token 出现，积累出分布式定义，用最少 token 锚定一整片行为。自造词不带先验，能用现成词就不自造。
7. **正向表述**："不要想大象"只会让大象占满注意力。禁令是弱修饰语，会被强激活的概念淹没。写目标行为（"写单行注释"），别写禁止行为；万不得已的硬护栏也要配上正向目标。
8. **剪枝纪律**：单一事实源（改行为=改一处）；**环境也是事实源**（package.json、目录结构本身），文档复述环境=缓存，只缓存查不到的东西（不成文约定、决策原因、坑）；逐句猎杀 **no-op**（模型默认就会做的指令=纯负载，删整句）；没有剪枝纪律的默认结局是**沉积**（sediment）。

## 四、单个 skill 的写法模式（从实例归纳）

- **一个 skill 对准一个失败模式**，不是一个话题。`tdd` 治"先写实现"，`grilling` 治"没对齐就开工"，`wait-what` 治"话没说明白"。
- **典型结构**：frontmatter → 一句话定位（这是什么、不是什么）→ 有序步骤（Process）→ 内联模板（`<spec-template>` 这类 XML 标签包裹）→ "Why" 小节解释设计原因 → Out of scope。
- **语气是纪律性的**："Do NOT interview the user — just synthesize"、"never `--abort`"、"Do not proceed to hypothesise without a loop"。skill 把 AI 塑造成内化了某种文化的、有主见的队友。
- **skill 可以极短**：`implement` 只有 6 行——它只做编排（调 `/tdd`、收尾调 `/code-review`），细节全在被调用的纪律 skill 里。
- **状态外置到文件系统**，不靠对话记忆：术语进 `CONTEXT.md`，决策进 ADR，工单进 `.scratch/<feature>/issues/`，交接进 handoff 文档。**上下文窗口是易失的，文件是持久的。**
- **子代理隔离防污染**：`code-review` 的两条审查轴（Standards / Spec）跑在并行子代理里，报告并列呈现、**不合并不重排**——防止一条轴掩盖另一条。
- **工单尺寸以上下文窗口为单位**：`to-tickets` 要求每个 vertical slice "sized to fit in a single fresh context window"，并声明 blocking edges。
- **不写会过时的东西**：spec 和 ticket 里不放文件路径、不放代码片段（"They may end up being outdated very quickly"）——环境即事实源的推论。

## 五、三个孵化中的写作 skill（对我们最直接的参考）

`in-progress/` 里有 Matt 自己的写作流水线，核心机制：

1. **explore / exploit 明确分相**：
   - `writing-fragments`（explore）：无结构地访谈挖掘"碎片"——能进最终文章的任何文字（金句、断言、小场景、半个想法、leading word）。原型是**小说家的日记**："years of unstructured noticings that later get mined"。禁止在此阶段强加结构。
   - `writing-beats` / `writing-shape`（exploit）：素材堆固定后，承诺一条路径，从堆里开采填充结构。
2. **Grounding 账本**：每个概念在被依赖前必须已被"接地"（读者带进来的前置，或被前文引入）。每个 beat 做两件事：**依赖**已接地的概念、**接地**新概念。维护一份运行中的已接地清单——这就是伏笔/信息差账本的原型。
3. **一次只写一个 beat，绝不超前**；每次写之前**从磁盘重读文件**，绝对尊重用户在两轮之间做的手工编辑。
4. **choose-your-own-adventure**：每步给 2–3 个候选下一拍，说明各自会"接地"什么、解锁哪些后续路径，用户选。

## 六、流程哲学（ask-matt 定义的主流程）

```
想法 → /grill-with-docs（访谈对齐，沉淀进 CONTEXT.md/ADR）
     → [需要可运行答案？→ /prototype 绕行，/handoff 进出]
     → 单次会话能完成？
        否 → /to-spec → /to-tickets（tracer-bullet 工单）→ 逐个 /implement（每个前 /clear）
        是 → 直接 /implement
     → /implement 内部驱动 /tdd，收尾 /code-review，提交
```

- **grilling 原语**：按"轮"工作，每轮问完整个 frontier（前置已定、现在就能问的所有问题），每题给推荐答案。**事实是 agent 的事（派子代理去查），决策是用户的事（提问并等待）。**
- **Context hygiene**：对齐→spec→拆票保持在一个不间断窗口里；每个 implement 从新窗口开始。模型有"smart zone"（约 150k token），逼近就在 phase boundary 处理（五选一：continue / clear / handoff / subagent / compact）。
- **三支柱**：动工前对齐、共享领域语言、持续反馈回路。

## 七、对我们最重要的十条移植原则

1. 双轨调用 + router，用户触发型互不调用。
2. 一个 skill = 一个失败模式。
3. 状态外置：圣经、账本、场景卡全是文件，不是对话记忆。
4. 工单（场景卡）尺寸 = 一个新鲜上下文窗口。
5. 完成判据要可检查、要穷尽（"每条伏笔已核对"而非"检查伏笔"）。
6. Leading words：为叙事纪律选好锚点词（如 出场费/账本/信息差/轴）。
7. 正向表述文风规则，避免禁令式 prompt。
8. 分轴修订，轴间隔离，不合并重排。
9. explore/exploit 分相 + grounding 账本（直接来自 writing-* 三件套）。
10. 剪枝纪律：no-op 猎杀、单一事实源、警惕沉积。
