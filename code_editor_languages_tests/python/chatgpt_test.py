from dotenv import load_dotenv
from langchain import hub
from langchain.agents import AgentExecutor, load_tools
from langchain.agents.format_scratchpad import format_log_to_str
from langchain.agents.output_parsers import ReActJsonSingleInputOutputParser
from langchain.tools.render import render_text_description
from langchain_community.chat_models.mlx import ChatMLX  # type: ignore
from langchain_community.llms.mlx_pipeline import MLXPipeline  # type: ignore

load_dotenv()
llm = MLXPipeline.from_model_id(
    "mlx-community/Phi-3-mini-4k-instruct-4bit",
    pipeline_kwargs={"max_tokens": 512, "temp": 0.1},
)

# messages = [
#     HumanMessage(
#         content="What happens when an unstoppable force meets an immovable object?"
#     ),
# ]
#
chat_model = ChatMLX(llm=llm)
#
# chat_model._to_chat_prompt(messages)
# res = chat_model.invoke(messages)
# print(res.content)

# setup tools
tools = load_tools(["serpapi", "llm-math"], llm=llm)

# setup ReAct style prompt
prompt = hub.pull("hwchase17/react-json")
prompt = prompt.partial(
    tools=render_text_description(tools),
    tool_names=", ".join([t.name for t in tools]),
)

# define the agent
chat_model_with_stop = chat_model.bind(stop=["\nObservation"])
agent = (
    {
        "input": lambda x: x["input"],
        "agent_scratchpad": lambda x: format_log_to_str(x["intermediate_steps"]),
    }
    | prompt
    | chat_model_with_stop
    | ReActJsonSingleInputOutputParser()
)

# instantiate AgentExecutor
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

res = agent_executor.invoke(
    {
        "input": "Who is Leo DiCaprio's girlfriend? What is her current age raised to the 0.43 power?"
    }
)
print(res)
