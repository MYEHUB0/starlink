package com.kh.idolsns.repo;
import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.kh.idolsns.dto.ChatMessageDto;

@Repository
public class ChatMessageRepoImpl implements ChatMessageRepo {

	@Autowired
	private SqlSession sql;

	@Override
	public int sequence() {
		return sql.selectOne("chatMessage.sequence");
	}
	@Override
	public void sendMessage(ChatMessageDto dto) {
		sql.insert("chatMessage.sendMessage", dto);
	}
	@Override
	public List<ChatMessageDto> messageList(int chatRoomNo) {
		return sql.selectList("chatMessage.listMessage", chatRoomNo);
	}
	@Override
	public void deleteMessage(long chatMessageNo) {
		sql.delete("chatMessage.deleteMessage", chatMessageNo);
	}
	
}
